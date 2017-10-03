From: akpm@linux-foundation.org
Subject: [patch 02/51] kernel/params.c: align add_sysfs_param
 documentation with code
Date: Tue, 03 Oct 2017 16:14:18 -0700
Message-ID: <59d419ca.K77qxlAG7PzZ6eOj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58296 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXOT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:14:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jdelvare@suse.de, rusty@rustcorp.com.au

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
