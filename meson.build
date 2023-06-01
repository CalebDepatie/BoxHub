project('BoxHub', 'd', version: '0.0.1', license: 'MIT')

srcs = [
    'src/main.d'
]

deps = []

deps += dependency('gtkd-3', version: '3.10.0')

executable('BoxHub',
            srcs,
            dependencies: deps,
            install_dir: '/app/bin',
            install: true
)