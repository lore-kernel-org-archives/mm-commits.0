From: akpm@linux-foundation.org
Subject: + params-align-add_sysfs_param-documentation-with-code.patch
 added to -mm tree
Date: Wed, 27 Sep 2017 14:38:51 -0700
Message-ID: <59cc1a6b.uWocuG9c7uUn7gG+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44744 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbdI0Viw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 17:38:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/params.c: align add_sysfs_param documentation with code
has been added to the -mm tree.  Its filename is
     params-align-add_sysfs_param-documentation-with-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/params-align-add_sysfs_param-documentation-with-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/params-align-add_sysfs_param-documentation-with-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: kernel/params.c: align add_sysfs_param documentation with code

This parameter is named kp, so the documentation should use that.

Fixes: 9b473de87209 ("param: Fix duplicate module prefixes")
Link: http://lkml.kernel.org/r/20170919142656.64aea59e@endymion
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/params.c~params-align-add_sysfs_param-documentation-with-code kernel/params.c
--- a/kernel/params.c~params-align-add_sysfs_param-documentation-with-code
+++ a/kernel/params.c
@@ -600,7 +600,7 @@ EXPORT_SYMBOL(kernel_param_unlock);
 /*
  * add_sysfs_param - add a parameter to sysfs
  * @mk: struct module_kobject
- * @kparam: the actual parameter definition to add to sysfs
+ * @kp: the actual parameter definition to add to sysfs
  * @name: name of parameter
  *
  * Create a kobject if for a (per-module) parameter if mp NULL, and
_

Patches currently in -mm which might be from jdelvare@suse.de are

params-align-add_sysfs_param-documentation-with-code.patch

