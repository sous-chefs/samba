# frozen_string_literal: true

name 'samba'

run_list 'test::server'

cookbook 'samba', path: '.'
cookbook 'test', path: 'test/fixtures/cookbooks/test'
