#! /usr/bin/perl

use warnings;
use strict;
use Carp;

sub licenseFileToVar($$) {
  my ($var,$file)=@_;

  my $ret;


  open(IN, $file) or croak;
  my $l = join("", <IN>);
  $l =~ s/\r//g;
  $l =~ s/\f//g;
  $l =~ s/\"/\\\"/g;

  $l = join("\\n\"\n\t\"",split(/\n/, $l));

  return qq!static const char *${var} = \n\t\"! . $l . "\";\n";
}

sub printGuarded($$$) {
  my ($F, $S, $Guard)=@_;
  
  if ($Guard) {
    print $F "#ifdef " . $Guard . "\n";
  }
  print $F $S;
  
  if ($Guard) {
    print $F "#endif\n";
  }
}


open(my $F, "> ../src/mumble/licenses.h");
binmode $F; # Ensure consistent file endings across platforms

print $F "/*\n";
print $F " * This file was auto-generated by scripts/mklic.pl\n";
print $F " * DO NOT EDIT IT MANUALLY\n";
print $F " */\n";
print $F "#ifndef MUMBLE_MUMBLE_LICENSES_H_\n";
print $F "#define MUMBLE_MUMBLE_LICENSES_H_\n";
print $F "\n";
print $F "#include <QtGlobal>\n";
print $F "\n";
print $F "struct ThirdPartyLicense {\n";
print $F "	const char* name;\n";
print $F "	const char* url;\n";
print $F "	const char* license;\n";
print $F "\n";
print $F "	ThirdPartyLicense() : name(0), url(0), license(0) {}\n";
print $F "	ThirdPartyLicense(const char* name, const char* url, const char* license)\n";
print $F "	    : name(name), url(url), license(license) {}\n";
print $F "	bool isEmpty() const { return (name == 0 && url == 0 && license == 0); }\n";
print $F "};\n";
print $F "\n";


print $F licenseFileToVar("licenseMumble", "../LICENSE");
print $F "\n\n";

# List of 3rd party licenses  [<variableName>, <pathToLicenseFile>, <DisplayName>, <URL>]
my @thirdPartyLicenses = (
    ["licenseCELT", "../celt-0.11.0-src/COPYING", "CELT", "http://www.celt-codec.org/"],
    ["licenseOpus", "../opus-src/COPYING", "Opus", "http://www.opus-codec.org/"],
    ["licenseSPEEX", "../speex/COPYING", "Speex", "http://www.speex.org/"],
    ["licenseOpenSSL", "../3rdPartyLicenses/openssl_license.txt", "OpenSSL", "http://www.openssl.org/"],
    ["licenseLibsndfile", "../3rdPartyLicenses/libsndfile_license.txt", "libsndfile", "http://www.mega-nerd.com/libsndfile/"],
    ["licenseOgg", "../3rdPartyLicenses/libogg_license.txt", "libogg", "http://www.xiph.org/"],
    ["licenseVorbis", "../3rdPartyLicenses/libvorbis_license.txt", "libvorbis", "http://www.xiph.org/"],
    ["licenseFLAC", "../3rdPartyLicenses/libflac_license.txt", "libFLAC", "http://flac.sourceforge.net/"],
    ["licenseMachOverride", "../3rdPartyLicenses/mach_override_license.txt", "mach_override", "https://github.com/rentzsch/mach_star", "Q_OS_MAC"],
    ["licenseQtTranslations", "../src/mumble/qttranslations/LICENSE",
        "Additional Qt translations", "https://www.virtualbox.org/ticket/2018", "USING_BUNDLED_QT_TRANSLATIONS"],
    ["licenseFilterSvg", "../icons/filter.txt", "filter.svg icon", "https://commons.wikimedia.org/wiki/File:Filter.svg"],
);

# Print 3rd party licenses
foreach (@thirdPartyLicenses) {
    printGuarded($F, licenseFileToVar(@$_[0], @$_[1]), @$_[4]);
    print $F "\n\n";
}


# Print list of 3rd party licenses
print $F "static const ThirdPartyLicense licenses3rdParties[] = {\n";
foreach (@thirdPartyLicenses) {
    printGuarded($F, "\tThirdPartyLicense(\"" . @$_[2] . "\", \"" . @$_[3] . "\", " . @$_[0] . "),\n", @$_[4]);
}
# Empty entry that marks the end of the array
printGuarded($F, "\tThirdPartyLicense(),\n", @$_[4]);
print $F "};\n\n\n";

print $F "#endif\n";

close($F);
