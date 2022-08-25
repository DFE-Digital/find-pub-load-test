require 'ruby-jmeter'

BASEURL = ENV.fetch('JMETER_TARGET_BASEURL', 'http://localhost:3002')
WAIT_FACTOR = ENV.fetch('JMETER_WAIT_FACTOR', 1).to_f
THREAD_COUNT = ENV.fetch('JMETER_THREAD_COUNT', 200)
RAMPUP = ENV.fetch('JMETER_RAMPUP', 0).to_i

def url(path)
  BASEURL + path
end

def submit!(name, path, params, &block)
  submit(name: name, url: url(path), fill_in: params, 'DO_MULTIPART_POST': 'true', &block)
end

test do
  cookies clear_each_iteration: true
  view_results_tree
  thread_count = THREAD_COUNT
  random_timer 1000, 2000 * WAIT_FACTOR
  csv_data_set_config filename: 'jmeter-find-params.csv',
                      ignoreFirstLine: true,
                      quotedData: true

  threads count: THREAD_COUNT, rampup: RAMPUP, duration: 1800 do
    visit name: 'Start page', url: url('/') do
      extract name: 'authenticity_token', regex: 'name="authenticity_token" value="(.+?)"'
    end

    visit name: 'Results page', url: url('/results?age_group=secondary&fulltime=false&hasvacancies=true&l=2&parttime=false&qualifications%5B%5D=QtsOnly&qualifications%5B%5D=PgdePgceWithQts&qualifications%5B%5D=Other&senCourses=false&subject_codes%5B%5D=W1&subject_codes%5B%5D=C1&subject_codes%5B%5D=08&subject_codes%5B%5D=F1&subject_codes%5B%5D=09&subject_codes%5B%5D=Q8&subject_codes%5B%5D=P3&subject_codes%5B%5D=11&subject_codes%5B%5D=12&subject_codes%5B%5D=DT&subject_codes%5B%5D=13&subject_codes%5B%5D=L1&subject_codes%5B%5D=Q3&subject_codes%5B%5D=16&subject_codes%5B%5D=15&subject_codes%5B%5D=F8&subject_codes%5B%5D=17&subject_codes%5B%5D=L5&subject_codes%5B%5D=V1&subject_codes%5B%5D=18&subject_codes%5B%5D=19&subject_codes%5B%5D=A0&subject_codes%5B%5D=20&subject_codes%5B%5D=G1&subject_codes%5B%5D=24&subject_codes%5B%5D=W3&subject_codes%5B%5D=C6&subject_codes%5B%5D=C7&subject_codes%5B%5D=F3&subject_codes%5B%5D=C8&subject_codes%5B%5D=V6&subject_codes%5B%5D=21&subject_codes%5B%5D=F0&subject_codes%5B%5D=14&subject_codes%5B%5D=22') do
      extract name: 'authenticity_token', regex: 'name="authenticity_token" value="(.+?)"'
    end

    visit name: 'Course page', url: url('/course/2AT/2T84') do
      extract name: 'authenticity_token', regex: 'name="authenticity_token" value="(.+?)"'
    end

    visit name: 'Accessibility', url: url('/accessibility') do
      extract name: 'authenticity_token', regex: 'name="authenticity_token" value="(.+?)"'
    end
  end
end.jmx
