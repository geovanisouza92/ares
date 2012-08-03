/* Ares Programming Language */

#include "st.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        SyntaxNode::~SyntaxNode () { }

        NodeType::Type
        SyntaxNode::getNodeType ()
        {
            return nodeType;
        }

        void
        SyntaxNode::setNodeType (NodeType::Type t)
        {
            nodeType = t;
        }

        Environment::Environment (Environment * p)
            : parent (p), statements (new VectorNode ()) { }

        Environment::~Environment () { }

        Environment *
        Environment::clear ()
        {
            statements->clear ();
            return this;
        }

        Environment *
        Environment::putStatements (VectorNode * v)
        {
            for (VectorNode::iterator stmt = v->begin (); stmt < v->end (); stmt++)
                statements->push_back (*stmt);
            return this;
        }

        void
        Environment::printUsing (ostream & out, unsigned d)
        {
            for (VectorNode::iterator stmt = statements->begin (); stmt < statements->end (); stmt++)
                (*stmt)->printUsing (out, 0);
        }

        NullNode::NullNode ()
        {
            setNodeType (NodeType::Null);
        }

        void
        NullNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Null" << endl;
        }

        IdentifierNode::IdentifierNode (string v)
            : value (v)
        {
            setNodeType (NodeType::Identifier);
        }

        void
        IdentifierNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Identifier => " << value << endl;
        }

        CharNode::CharNode (char v)
            : value (v)
        {
            setNodeType (NodeType::Char);
        }

        void
        CharNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Char => " << value << endl;
        }

        StringNode::StringNode (string v)
            : value (v)
        {
            setNodeType (NodeType::String);
        }

        void
        StringNode::append (string v)
        {
            value += v;
        }

        void
        StringNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "String => " << value << endl;
        }

        RegexNode::RegexNode (string v)
            : value (v)
        {
            setNodeType (NodeType::Regex);
        }

        void
        RegexNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Regex => " << value << endl;
        }

        FloatNode::FloatNode (double v)
            : value (v)
        {
            setNodeType(NodeType::Float);
        }

        void
        FloatNode::printUsing(ostream & out, unsigned d)
        {
            TAB(d) << "Float => " << value << endl;
        }

        IntegerNode::IntegerNode (int v)
            : value (v)
        {
            setNodeType (NodeType::Integer);
        }

        void
        IntegerNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Integer => " << value << endl;
        }

        BooleanNode::BooleanNode (bool v)
            : value (v)
        {
            setNodeType (NodeType::Boolean);
        }

        void
        BooleanNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Boolean => " << (value ? "True" : "False") << endl;
        }

        ArrayNode::ArrayNode ()
            : value (new VectorNode ())
        {
            setNodeType (NodeType::Array);
        }

        ArrayNode::ArrayNode (VectorNode * v)
            : value (v)
        {
            setNodeType (NodeType::Array);
        }

        void
        ArrayNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Array => [" << endl;
            for (VectorNode::iterator elem = value->begin (); elem < value->end (); elem++) {
                (*elem)->printUsing (out, d + 1);
                if (elem != value->end () - 1) TAB(d + 2) << ", " << endl;
            }
            TAB(d) << "]" << endl;
        }

        KeyValuePairNode::KeyValuePairNode (SyntaxNode * k, SyntaxNode * v)
            : key (k), value (v)
        {
            setNodeType (NodeType::HashPair);
        }

        void
        KeyValuePairNode::printUsing (ostream & out, unsigned d)
        {
            key->printUsing (out, d + 1);
            TAB (d + 1) << "^" << endl;
            value->printUsing (out, d + 1);
        }

        HashNode::HashNode() : value (new VectorNode ())
        {
            setNodeType (NodeType::Hash);
        }

        HashNode::HashNode (VectorNode * v)
            : value (v)
        {
            setNodeType (NodeType::Hash);
        }

        void
        HashNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Hash => {" << endl;
            for (VectorNode::iterator elem = value->begin (); elem < value->end (); elem++) {
                (*elem)->printUsing (out, d + 1);
                if (elem != value->end () - 1) TAB(d + 2) << ", " << endl;
            }
            TAB(d) << "}" << endl;
        }

        void
        UnaryExpressionNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Unary expression [ " << BasicOperator::getEnumName (op) << " ] =>" << endl;
            member1->printUsing (out, d + 1);
        }

        UnaryExpressionNode::UnaryExpressionNode (BasicOperator::Operator op, SyntaxNode * m1)
            : op (op), member1 (m1)
        {
            setNodeType (NodeType::Null);
        }

        UnaryExpressionNode::UnaryExpressionNode (BasicOperator::Operator op, VectorNode * m1)
            : op (op), vector1 (m1)
        {
            setNodeType (NodeType::Null);
        }

        BinaryExpressionNode::BinaryExpressionNode (BasicOperator::Operator op, SyntaxNode * m1, SyntaxNode * m2)
            : op (op), member1 (m1), member2 (m2)
        {
            setNodeType (NodeType::Null);
        }

        void
        BinaryExpressionNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Binary expression [ " << BasicOperator::getEnumName (op) << " ] =>" << endl;
            member1->printUsing (out, d + 1);
            member2->printUsing (out, d + 1);
        }

        TernaryExpressionNode::TernaryExpressionNode (BasicOperator::Operator op, SyntaxNode *m1, SyntaxNode *m2, SyntaxNode *m3)
            : op (op), member1 (m1), member2 (m2), member3 (m3)
        {
            setNodeType (NodeType::Null);
        }

        void
        TernaryExpressionNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Ternary expression [ " << BasicOperator::getEnumName (op) << " ] =>" << endl;
            member1->printUsing (out, d + 1);
            member2->printUsing (out, d + 1);
            member3->printUsing (out, d + 1);
        }

        FunctionInvocationNode::FunctionInvocationNode (SyntaxNode * n)
            : functionName (n), functionArguments (new VectorNode ())
        {
            setNodeType (NodeType::Null);
        }

        FunctionInvocationNode::FunctionInvocationNode (SyntaxNode * n, VectorNode * a)
            : functionName (n), functionArguments (a)
        {
            setNodeType (NodeType::Null);
        }

        void
        FunctionInvocationNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Function call for =>" << endl;
            functionName->printUsing (out, d + 1);
            if (functionArguments->size () > 0) {
                TAB(d + 1) << "with arguments (" << endl;
                for (VectorNode::iterator arg = functionArguments->begin (); arg < functionArguments->end (); arg++) {
                    (*arg)->printUsing (out, d + 2);
                    if (arg != functionArguments->end () - 1) TAB(d + 2) << ", " << endl;
                }
                TAB(d) << ")" << endl;
            }
        }

        LambdaExpressionNode::LambdaExpressionNode (VectorNode * a, SyntaxNode * e)
            : lambdaArguments (a), lambdaExpression (e) { }

        void
        LambdaExpressionNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Lambda expression ";
            if (lambdaArguments->size () > 0) {
                out << "with arguments (" << endl;
                for (VectorNode::iterator arg = lambdaArguments->begin (); arg < lambdaArguments->end (); arg++) {
                    (*arg)->printUsing (out, d + 1);
                    if (arg != lambdaArguments->end () - 1) TAB(d + 2) << ", " << endl;
                }
                TAB(d) << ") ";
            }
            out << "using expression =>" << endl;
            lambdaExpression->printUsing (out, d + 1);
        }
    } // SyntaxTree
} // LANG_NAMESPACE
