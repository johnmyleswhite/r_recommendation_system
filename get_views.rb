#!/usr/bin/ruby

base_url = 'http://cran.r-project.org/web/views/'

task_views = [
              ['Bayesian.html', 'Bayesian'],
              ['ChemPhys.html', 'ChemPhys'],
              ['ClinicalTrials.html', 'ClinicalTrials'],
              ['Cluster.html', 'Cluster'],
              ['Distributions.html', 'Distributions'],
              ['Econometrics.html', 'Econometrics'],
              ['Environmetrics.html', 'Environmetrics'],
              ['ExperimentalDesign.html', 'ExperimentalDesign'],
              ['Finance.html', 'Finance'],
              ['Genetics.html', 'Genetics'],
              ['Graphics.html', 'Graphics'],
              ['gR.html', 'gR'],
              ['HighPerformanceComputing.html', 'HighPerformanceComputing'],
              ['MachineLearning.html', 'MachineLearning'],
              ['MedicalImaging.html', 'MedicalImaging'],
              ['Multivariate.html', 'Multivariate'],
              ['NaturalLanguageProcessing.html', 'NaturalLanguageProcessing'],
              ['OfficialStatistics.html', 'OfficialStatistics'],
              ['Optimization.html', 'Optimization'],
              ['Pharmacokinetics.html', 'Pharmacokinetics'],
              ['Phylogenetics.html', 'Phylogenetics'],
              ['Psychometrics.html', 'Psychometrics'],
              ['ReproducibleResearch.html', 'ReproducibleResearch'],
              ['Robust.html', 'Robust'],
              ['SocialSciences.html', 'SocialSciences'],
              ['Spatial.html', 'Spatial'],
              ['Survival.html', 'Survival'],
              ['TimeSeries.html', 'TimeSeries']
             ]

data_file = File.new('data/views.csv', 'w')

data_file.puts("\"View\",\"LinkedPackage\"")

task_views.each do |task_view|
  sleep(10)
  url = base_url + task_view[0]
  view = task_view[1]
  `curl #{url} > tmp.html`  
  html = File.open('tmp.html', 'r') {|f| f.read()}
  packages = html.scan(Regexp.new('<li><a href="\.\./packages/[^/]+/index.html">([^<]+)</a></li>')).flatten
  packages.each do |package|
    data_file.puts "\"#{view}\",\"#{package}\""
  end
  `rm tmp.html`
end

data_file.close
