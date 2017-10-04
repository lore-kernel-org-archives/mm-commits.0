From: akpm@linux-foundation.org
Subject: [merged]
 params-align-add_sysfs_param-documentation-with-code.patch removed from -mm
 tree
Date: Wed, 04 Oct 2017 12:39:55 -0700
Message-ID: <20171004193955.IoAgt3rXU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTj4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:39:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, mm-commits@vger.kernel.org, rusty@rustcorp.com.au


The patch titled
     Subject: kernel/params.c: align add_sysfs_param documentation with code
has been removed from the -mm tree.  Its filename was
     params-align-add_sysfs_param-documentation-with-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


