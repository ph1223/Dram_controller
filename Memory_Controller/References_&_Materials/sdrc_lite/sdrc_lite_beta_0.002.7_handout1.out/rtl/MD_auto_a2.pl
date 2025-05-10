#!/usr/bin/perl -w
#Author: Liang Chen <cyboic@gmail.com>
#-------------------------------------------------------------------------------
#Software requirements:
#The author recommend the Modelsim-Debussy setup method from the link below.
#	http://www.cnblogs.com/yuphone/archive/2010/05/31/1747871.html
#The author assume that "tee" command is in your system PATH,
#	and coreutils package from gnuwin32 is recommend.
#	http://gnuwin32.sourceforge.net/packages/coreutils.html
#-------------------------------------------------------------------------------
use strict;
use File::Spec; #used to make this program OS-independent
use File::Copy; #used to copy files
use File::Path; #used to remove dir that is not empty
use File::Find;	#used to look for a file recusively
use Cwd;        #used to get current working dir
#-------------------------------------------------------------------------------
#Tool path
my $debussy_path = "C:\\Novas\\Debussy\\bin\\Debussy.exe";
my $vsim_path = "C:\\modeltech_6.5f\\win32\\vsim.exe";
my $bat_hder = "This bat file is a auto-generated file.\n";
my $vsim_log_fl = "vsim_log.txt";
#-------------------------------------------------------------------------------
#configure path
my $indir = getcwd();#
my @indir = File::Spec->splitdir($indir);#
my $source_path = $ARGV[1]? File::Spec->rel2abs($ARGV[1])
	: File::Spec->catdir(@indir);#
my @source_path = File::Spec->splitdir($source_path);#
my @srcprt_path = File::Spec->splitdir($source_path);#
pop @srcprt_path;
=cut
my $target_path = $ARGV[2]? File::Spec->rel2abs($ARGV[2])
	: File::Spec->catdir(@indir);#
my @target_path = File::Spec->splitdir($target_path);#
#delete old version if any and create new version dir
(-e "$target_path") and ($target_path ne $source_path) and rmtree($target_path);
($target_path ne $source_path) and mkdir "${target_path}", 0777;
=cut
#-------------------------------------------------------------------------------
#search bit file in $source_path
my @tbv2hndl = ();
if((! $ARGV[0]) or ($ARGV[0] eq "*")){
	find(\&tbv_srch, "$source_path");
}
else{
	@tbv2hndl = split /,/, $ARGV[0];
}
$tbv2hndl[0] or die "No verilog testbench file to handle!";
#-------------------------------------------------------------------------------
#Process verilog testbench files in @source_path
for my $tar_tbv (@tbv2hndl) {
	&tb_dirgen($tar_tbv);
}
#-------------------------------------------------------------------------------
#generate modelsim debussy simulation dir
sub tb_dirgen{
	my ($tar_tbv) = @_;
	print "processing ${tar_tbv}.v\n";
	my @tbvsim_path = (@srcprt_path, "vsim_${tar_tbv}");
	my $tbvsim_path = File::Spec->catdir(@tbvsim_path);
	if($tbvsim_path ne $source_path){
		(-e "$tbvsim_path") and rmtree($tbvsim_path);
		mkdir "$tbvsim_path", 0777;
	}
	print $tbvsim_path."\n";
	#generate rtl.f for vsim and nsim
	my $rtlf_fl = File::Spec->catfile(@tbvsim_path, "rtl.f");
	&rtlfgen($tar_tbv, $rtlf_fl);
	#generate modelsim sim.do file
	my $simdo_fl = File::Spec->catfile(@tbvsim_path, "sim.do");
	&simdogen($tar_tbv, $simdo_fl);
	#generate modelsim run_vsim_only.bat file
	my $mbat_fl = File::Spec->catfile(@tbvsim_path, "run_vsim_only.bat");
	&mbatgen($vsim_path, $bat_hder, $tar_tbv, $mbat_fl);
	#generate debussy nWave.bat file
	my $dbat_fl = File::Spec->catfile(@tbvsim_path, "nWave.bat");
	&dbatgen($debussy_path, $bat_hder, $tar_tbv, $dbat_fl);
	#generate modelsim-debussy run.bat file
	my $mdbat_fl = File::Spec->catfile(@tbvsim_path, "run.bat");
	&mdbatgen($debussy_path, $vsim_path, $bat_hder, $tar_tbv, $mdbat_fl);
	print "ok!\n\n";
}
#-------------------------------------------------------------------------------
#generate rtl.f for vsim and nsim
sub rtlfgen{
	my ($tar_tbv, $rtlf_fl) = @_;
	open RTLF_FH, ">", $rtlf_fl or die "Cannot open $rtlf_fl for write.\n";
	my %tar_tbv_mdls = ();
	#recursivele find submodules of tar_mdl
	&findsub($tar_tbv, \%tar_tbv_mdls);
	my $rtlf_txt = "";
	$rtlf_txt .= "../rtl/${tar_tbv}.v\n";
	for (sort(keys(%tar_tbv_mdls))){
		$rtlf_txt .= "../rtl/$_.v\n";
	};
	print RTLF_FH $rtlf_txt;
	close RTLF_FH;
}
#-------------------------------------------------------------------------------
#recursivele find submodules of tar_mdl
sub findsub{
	my ($tar_mdl, $sub_mdls_pt) = @_;
	my @submdls_lv1 = ();
	my $tar_v_fl = "${tar_mdl}.v";
	open TAR_V_FH, "<", $tar_v_fl or die "Cannot open $tar_v_fl for read.\n";
	while (<TAR_V_FH>){
        /^\s*(module|nmos|pmos|n12|p12|nlvt12|plvt12|else)\s+\w+\s*\(/ and next;
		/^\s*(assign|initial|always)\s+/ and next;
        if(/^\s*(\w+)\s+\w+\s*\(/ or /^\s*(\w+)\s+\#\s*\(/){
			$sub_mdls_pt->{"$1"}="1";
			push @submdls_lv1, $1;
		}
	}
	for (@submdls_lv1){
		findsub($_, $sub_mdls_pt);
	}
	close TAR_V_FH;
}
#-------------------------------------------------------------------------------
#generate modelsim sim.do file
sub simdogen{
	my ($tar_tbv, $simdo_fl) = @_;
	open SIMDO_FH, ">", $simdo_fl or die "Cannot open $simdo_fl for write.\n";
	my $simdo_txt = "";
	$simdo_txt .= "vlib work\n";
	$simdo_txt .= "vlog -f rtl.f\n";
	$simdo_txt .= "vsim work.${tar_tbv}\n";
	$simdo_txt .= "run -all\n";
	$simdo_txt .= "q\n";
	print SIMDO_FH $simdo_txt;
	close SIMDO_FH;
}
#-------------------------------------------------------------------------------
#generate modelsim run_vsim_only.bat file
sub mbatgen{
	my ($vsim_path, $bat_hder, $tar_tbv, $mbat_fl) = @_;
	open MABT_FH, ">", $mbat_fl or die "Cannot open $mbat_fl for write.\n";
	my $mbat_txt = "";
	$mbat_txt .= "::${bat_hder}";
	$mbat_txt .= "\@ECHO OFF\n";
	$mbat_txt .= "SET vsim=${vsim_path}\n";
	$mbat_txt .= "\%vsim\% -c -do sim.do  | tee ${vsim_log_fl}\n";
	$mbat_txt .= "RD work /s /q\n";
	$mbat_txt .= "DEL transcript vsim.wlf /q\n";
	$mbat_txt .= "pause\n";
	print MABT_FH $mbat_txt;
	close MABT_FH;
}
#-------------------------------------------------------------------------------
#generate debussy nWave.bat file
sub dbatgen{
	my ($debussy_path, $bat_hder, $tar_tbv, $dbat_fl) = @_;
	open DABT_FH, ">", $dbat_fl or die "Cannot open $dbat_fl for write.\n";
	my $dbat_txt = "";
	$dbat_txt .= "::${bat_hder}";
	$dbat_txt .= "\@ECHO OFF\n";
	$dbat_txt .= "SET debussy=${debussy_path}\n";
	$dbat_txt .= "\%debussy\% -nWave \%*\n";
	$dbat_txt .= "RD Debussy.exeLog  /s /q\n";
	$dbat_txt .= "DEL novas.rc /q\n";
	$dbat_txt .= "EXIT\n";
	print DABT_FH $dbat_txt;
	close DABT_FH;
}
#-------------------------------------------------------------------------------
#generate modelsim-debussy run.bat file
sub mdbatgen{
	my ($debussy_path, $vsim_path, $bat_hder, $tar_tbv, $mdbat_fl) = @_;
	open MDABT_FH, ">", $mdbat_fl or die "Cannot open $mdbat_fl for write.\n";
	my $mdbat_txt = "";	
	$mdbat_txt .= "::${bat_hder}";
	$mdbat_txt .= "\@ECHO OFF\n";
	$mdbat_txt .= "SET debussy=${debussy_path}\n";
	$mdbat_txt .= "SET vsim=${vsim_path}\n";
	$mdbat_txt .= "\%vsim\% -c -do sim.do  | tee ${vsim_log_fl}\n";
	$mdbat_txt .= "RD work /s /q\n";
	$mdbat_txt .= "DEL transcript vsim.wlf /q\n";
	$mdbat_txt .= "%debussy% -f rtl.f -ssf ${tar_tbv}.fsdb -2001\n";
	$mdbat_txt .= "RD Debussy.exeLog  /s /q\n";
	$mdbat_txt .= "DEL novas.rc /q\n";
	$mdbat_txt .= "EXIT\n";
	print MDABT_FH $mdbat_txt;
	close MDABT_FH;
}
#-------------------------------------------------------------------------------
#used to auto detect bitfile when no arguments provided
sub tbv_srch{
	my $CSD = File::Spec->catdir(File::Spec->splitdir($File::Find::dir));
	/^([\w\-]+_tb)\.v$/ and ($CSD eq $source_path) and push @tbv2hndl, $1;
}
#-------------------------------------------------------------------------------
#Thing to improve: keep debussy .rc signal file.
#Is rtl.f with absolute path better?