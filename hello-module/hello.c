#include <linux/module.h>
#include <linux/init.h>
static int answer = 42; 												/* default parameter value */
module_param (answer, int,  S_IRUGO | S_IWUSR);	/* declare module parameter*/
MODULE_PARM_DESC(answer, "The answer for all the questions in the universe - as a module param");

static int __init load_me(void)
{
		pr_info("KATS: %s\n","\x1b[42mHOW ARE YOU GENTLEMEN !!\x1b[0m\n");
		return 0;
}
static void __exit unload_me(void)
{
		pr_info("KATS: %s\n","\x1b[41mALL YOUR BASE ARE BELONG TO US.\x1b[0m\n");
}

module_init(load_me); 
module_exit(unload_me);

MODULE_AUTHOR("Ron Munitz");
MODULE_DESCRIPTION("A Simple Loadable Kernel Module Example");
MODULE_LICENSE("GPL v2");
