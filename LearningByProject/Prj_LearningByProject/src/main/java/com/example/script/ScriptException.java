package com.example.script;

public class ScriptException extends Exception{
	
    // Parameterless Constructor
    public ScriptException() {}

    // Constructor that accepts a message
    public ScriptException(String message)
    {
       super(message);
    }
}


