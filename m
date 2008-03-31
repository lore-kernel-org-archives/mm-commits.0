From: akpm@linux-foundation.org
Subject: - audit-ailence-two-kerneldoc-warnings-in-kernel-auditc.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:17:39 -0700
Message-ID: <200803312017.m2VKHdQ2023989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756121AbYCaUSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:18:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@codemonkey.org.uk, randy.dunlap@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: silence two kerneldoc warnings in kernel/audit.c
has been removed from the -mm tree.  Its filename was
     audit-ailence-two-kerneldoc-warnings-in-kernel-auditc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: silence two kerneldoc warnings in kernel/audit.c
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
@@ -1269,8 +1269,8 @@ static void audit_log_n_string(struct au
 
 /**
  * audit_string_contains_control - does a string need to be logged in hex
- * @string - string to be checked
- * @len - max length of the string to check
+ * @string: string to be checked
+ * @len: max length of the string to check
  */
 int audit_string_contains_control(const char *string, size_t len)
 {
@@ -1285,7 +1285,7 @@ int audit_string_contains_control(const 
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

origin.patch
git-cpufreq.patch
cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism.patch
cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface.patch
allow-use-of-the-powersave-governor-as-the-default-one.patch
cpufreq-change-cpu-freq-arrays-to-per_cpu-variables.patch

