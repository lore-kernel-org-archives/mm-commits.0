Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69F2EB64DC
	for <mm-commits@archiver.kernel.org>; Sun, 25 Jun 2023 21:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjFYVpY convert rfc822-to-8bit (ORCPT
        <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Jun 2023 17:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjFYVpX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Jun 2023 17:45:23 -0400
X-Greylist: delayed 394 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 25 Jun 2023 14:45:21 PDT
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE409E
        for <mm-commits@vger.kernel.org>; Sun, 25 Jun 2023 14:45:21 -0700 (PDT)
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C6F61604C2;
        Sun, 25 Jun 2023 21:38:46 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf08.hostedemail.com (Postfix) with ESMTPA id 6C00320026;
        Sun, 25 Jun 2023 21:38:41 +0000 (UTC)
Message-ID: <419ec62b9e88140ac75bd2dae7c94b13acb6b015.camel@perches.com>
Subject: Re: + cred-convert-printks-to-pr_level.patch added to
 mm-nonmm-unstable branch
From:   Joe Perches <joe@perches.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, zwp10758@gmail.com,
        senozhatsky@chromium.org, pc@cjr.nz, mcgrof@kernel.org,
        keescook@chromium.org, gregkh@linuxfoundation.org,
        tiozhang@didiglobal.com
Date:   Sun, 25 Jun 2023 14:38:39 -0700
In-Reply-To: <20230625035813.A23CAC433C8@smtp.kernel.org>
References: <20230625035813.A23CAC433C8@smtp.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.48.3 (3.48.3-1.fc38) 
MIME-Version: 1.0
X-Stat-Signature: rfox9fdwqtxigc39yj6wa5i1heg5zjj4
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 6C00320026
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+TuDbeICqTGAq8fOhZCUxfKsRVQHytIE4=
X-HE-Tag: 1687729121-182425
X-HE-Meta: U2FsdGVkX19aMlyTgqhEyTErVgXQwXrZCPA83Ishxdk7vCjSrRCY1RrSYInODMYQ9WEWGFNE87LoYkeRfKBIdXYe4RJ2hNfNLepFgjpEDfCX4UKPPg8ymTbV47Z2jg5gp/BYEQqc/+iBQL32GWs39hnwXkJO3oa7dkr+HY9bKECF0blN5qEx9d2a3tRLSzYPE1MFiJrCjGVSQT6eTtg7N+lhyqDzMYPZUatkRroH+AkMIZV9On16JOnhls/a3zK52GBTiHEV3VA8rPH4JRP203Ou67LMGzJH8fSCnYzR91RBqghiXnwEYKDKds2ycw7Co6lOlFzJ9kIOwuoKxSgjMyLQ6D37bvdHCiIQnVHA51Sm14d8oPgEvViVR8uRnd4OsA22lhmFPYz4nRh8zU2O91CMB6wdBZ+P4ds784NHy/UE15Kzafjm/OiXlWJD6z33pe/F9D0PeSY3SqNl5KQQhuPcNXLWXo5NR5WcvFBRRIHtNGh17/750dhijF8eQL8p0YR0kfplWnB9aDMBugEakYycvM22gmf+Hqiwh0QEwISBzFkwB9ITUGAhsknET5jbCUV7Yv3wZi2v35Sh5QRemkL7w2mLEJ3vH3aBTuZSth5UN554ia98TiCPOB1HN7tRJzGdSJO8PNLzewvanhx1+ACWf0uk/9LK8POJK8Ai093Q6qyJ/mEAddLq5InGy44YQwqd095elE3H0RljuzbQTQ==
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, 2023-06-24 at 20:58 -0700, Andrew Morton wrote:
> The patch titled
>      Subject: cred: convert printks to pr_<level>
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      cred-convert-printks-to-pr_level.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cred-convert-printks-to-pr_level.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: tiozhang <tiozhang@didiglobal.com>
> Subject: cred: convert printks to pr_<level>
> Date: Sun, 25 Jun 2023 11:34:52 +0800
> 
> Use current logging style.
> 
> Link: https://lkml.kernel.org/r/20230625033452.GA22858@didi-ThinkCentre-M930t-N000
> Signed-off-by: tiozhang <tiozhang@didiglobal.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Joe Perches <joe@perches.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Paulo Alcantara <pc@cjr.nz>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Weiping Zhang <zwp10758@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/cred.c |   27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> --- a/kernel/cred.c~cred-convert-printks-to-pr_level
> +++ a/kernel/cred.c
> @@ -4,6 +4,9 @@
>   * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
>   * Written by David Howells (dhowells@redhat.com)
>   */
> +
> +#define pr_fmt(fmt) "CRED: " fmt

My preference would be to use

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

but it likely doesn't matter too much.

> +
>  #include <linux/export.h>
>  #include <linux/cred.h>
>  #include <linux/slab.h>
> @@ -835,32 +838,32 @@ EXPORT_SYMBOL(creds_are_invalid);
>  static void dump_invalid_creds(const struct cred *cred, const char *label,
>  			       const struct task_struct *tsk)
>  {
> -	printk(KERN_ERR "CRED: %s credentials: %p %s%s%s\n",
> +	pr_err("%s credentials: %p %s%s%s\n",
>  	       label, cred,
>  	       cred == &init_cred ? "[init]" : "",
>  	       cred == tsk->real_cred ? "[real]" : "",
>  	       cred == tsk->cred ? "[eff]" : "");
> -	printk(KERN_ERR "CRED: ->magic=%x, put_addr=%p\n",
> +	pr_err("->magic=%x, put_addr=%p\n",
>  	       cred->magic, cred->put_addr);
> -	printk(KERN_ERR "CRED: ->usage=%d, subscr=%d\n",
> +	pr_err("->usage=%d, subscr=%d\n",
>  	       atomic_read(&cred->usage),
>  	       read_cred_subscribers(cred));
> -	printk(KERN_ERR "CRED: ->*uid = { %d,%d,%d,%d }\n",
> +	pr_err("->*uid = { %d,%d,%d,%d }\n",
>  		from_kuid_munged(&init_user_ns, cred->uid),
>  		from_kuid_munged(&init_user_ns, cred->euid),
>  		from_kuid_munged(&init_user_ns, cred->suid),
>  		from_kuid_munged(&init_user_ns, cred->fsuid));
> -	printk(KERN_ERR "CRED: ->*gid = { %d,%d,%d,%d }\n",
> +	pr_err("->*gid = { %d,%d,%d,%d }\n",
>  		from_kgid_munged(&init_user_ns, cred->gid),
>  		from_kgid_munged(&init_user_ns, cred->egid),
>  		from_kgid_munged(&init_user_ns, cred->sgid),
>  		from_kgid_munged(&init_user_ns, cred->fsgid));
>  #ifdef CONFIG_SECURITY
> -	printk(KERN_ERR "CRED: ->security is %p\n", cred->security);
> +	pr_err("->security is %p\n", cred->security);
>  	if ((unsigned long) cred->security >= PAGE_SIZE &&
>  	    (((unsigned long) cred->security & 0xffffff00) !=
>  	     (POISON_FREE << 24 | POISON_FREE << 16 | POISON_FREE << 8)))
> -		printk(KERN_ERR "CRED: ->security {%x, %x}\n",
> +		pr_err("->security {%x, %x}\n",
>  		       ((u32*)cred->security)[0],
>  		       ((u32*)cred->security)[1]);
>  #endif
> @@ -871,8 +874,8 @@ static void dump_invalid_creds(const str
>   */
>  void __noreturn __invalid_creds(const struct cred *cred, const char *file, unsigned line)
>  {
> -	printk(KERN_ERR "CRED: Invalid credentials\n");
> -	printk(KERN_ERR "CRED: At %s:%u\n", file, line);
> +	pr_err("Invalid credentials\n");
> +	pr_err("At %s:%u\n", file, line);
>  	dump_invalid_creds(cred, "Specified", current);
>  	BUG();
>  }
> @@ -898,14 +901,14 @@ void __validate_process_creds(struct tas
>  	return;
>  
>  invalid_creds:
> -	printk(KERN_ERR "CRED: Invalid process credentials\n");
> -	printk(KERN_ERR "CRED: At %s:%u\n", file, line);
> +	pr_err("Invalid process credentials\n");
> +	pr_err("At %s:%u\n", file, line);
>  
>  	dump_invalid_creds(tsk->real_cred, "Real", tsk);
>  	if (tsk->cred != tsk->real_cred)
>  		dump_invalid_creds(tsk->cred, "Effective", tsk);
>  	else
> -		printk(KERN_ERR "CRED: Effective creds == Real creds\n");
> +		pr_err("Effective creds == Real creds\n");
>  	BUG();
>  }
>  EXPORT_SYMBOL(__validate_process_creds);
> _
> 
> Patches currently in -mm which might be from tiozhang@didiglobal.com are
> 
> cred-convert-printks-to-pr_level.patch
> 

