From: akpm@linux-foundation.org
Subject: + audit-ailence-two-kerneldoc-warnings-in-kernel-auditc.patch added to -mm tree
Date: Tue, 25 Mar 2008 15:48:55 -0700
Message-ID: <200803252248.m2PMmt6L017491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033AbYCYWtn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:49:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@codemonkey.org.uk, randy.dunlap@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     audit: ailence two kerneldoc warnings in kernel/audit.c
has been added to the -mm tree.  Its filename is
     audit-ailence-two-kerneldoc-warnings-in-kernel-auditc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: ailence two kerneldoc warnings in kernel/audit.c
From: Dave Jones <davej@codemonkey.org.uk>

Silence two kerneldoc warnings.

Warning(kernel/audit.c:1276): No description found for parameter 'string'
Warning(kernel/audit.c:1276): No description found for parameter 'len'

[also fix a typo for bonus points]

Signed-off-by: Dave Jones <davej@codemonkey.org.uk>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/audit.c~audit-ailence-two-kerneldoc-warnings-in-kernel-auditc kernel/audit.c
--- a/kernel/audit.c~audit-ailence-two-kerneldoc-warnings-in-kernel-auditc
+++ a/kernel/audit.c
@@ -1265,8 +1265,8 @@ static void audit_log_n_string(struct au
 
 /**
  * audit_string_contains_control - does a string need to be logged in hex
- * @string - string to be checked
- * @len - max length of the string to check
+ * @string: string to be checked
+ * @len: max length of the string to check
  */
 int audit_string_contains_control(const char *string, size_t len)
 {
@@ -1281,7 +1281,7 @@ int audit_string_contains_control(const 
 /**
  * audit_log_n_untrustedstring - log a string that may contain random characters
  * @ab: audit_buffer
- * @len: lenth of string (not including trailing null)
+ * @len: length of string (not including trailing null)
  * @string: string to be logged
  *
  * This code will escape a string that is passed to it if the string
_

Patches currently in -mm which might be from davej@codemonkey.org.uk are

git-cpufreq.patch
cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism.patch
cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface.patch
allow-use-of-the-powersave-governor-as-the-default-one.patch
audit-ailence-two-kerneldoc-warnings-in-kernel-auditc.patch

