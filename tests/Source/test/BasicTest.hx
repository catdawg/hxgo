package test;

import unittest.TestCase;

import tardis.*; // import the generated Go code

class BasicTest extends TestCase
{
    public function testSetupIsWorking()
    {
        var na2to3 = Go_math_NNextafter.hx(2.0,3.0);

        assertTrue(na2to3 > 2.0);
        assertTrue(na2to3 < 3.0);
    }
}
