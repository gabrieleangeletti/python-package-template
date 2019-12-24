from . import main


def test_main():
    expected = "Hello world!"
    actual = main.main()
    assert actual == expected
