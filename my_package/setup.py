from setuptools import find_packages, setup

setup(
    name="my-package",
    version="1.0.0",
    description="Description of my package.",
    install_requires=[],
    include_package_data=True,
    python_requires=">=3.7",
    packages=find_packages(),
    entry_points={"console_scripts": ["my_package=my_package.main:main"]},
)
