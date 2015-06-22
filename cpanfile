requires "Getopt::Long" => "2.42";
requires "HTTP::Tiny" => "0.054";
requires "JSON::MaybeXS" => "1.002006";
requires "perl" => "5.010001";

on 'build' => sub {
  requires "Module::Build" => "0.4004";
  requires "Test::Requires" => "0.06";
  requires "version" => "0.88";
};

on 'configure' => sub {
  requires "Module::Build" => "0.4004";
  requires "version" => "0.88";
};
