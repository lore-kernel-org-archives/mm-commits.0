From: akpm@linux-foundation.org
Subject: + include-linux-remove-strict_strto-definitions.patch added to
 -mm tree
Date: Mon, 23 Jun 2014 16:29:52 -0700
Message-ID: <53a8b870.0Q7anMs6TUDKDRpT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaFWX3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 19:29:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux: remove strict_strto* definitions
has been added to the -mm tree.  Its filename is
     include-linux-remove-strict_strto-definitions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-remove-strict_strto-definitions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-remove-strict_strto-definitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Walter <dwalter@google.com>
Subject: include/linux: remove strict_strto* definitions

Remove obsolete and unused strict_strto* functions

Signed-off-by: Daniel Walter <dwalter@google.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/linux/kernel.h~include-linux-remove-strict_strto-definitions include/linux/kernel.h
--- a/include/linux/kernel.h~include-linux-remove-strict_strto-definitions
+++ a/include/linux/kernel.h
@@ -376,10 +376,6 @@ extern unsigned long simple_strtoul(cons
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
 extern long long simple_strtoll(const char *,char **,unsigned int);
-#define strict_strtoul	kstrtoul
-#define strict_strtol	kstrtol
-#define strict_strtoull	kstrtoull
-#define strict_strtoll	kstrtoll
 
 extern int num_to_str(char *buf, int size, unsigned long long num);
 
_

Patches currently in -mm which might be from dwalter@google.com are

arch-arm-mach-omap2-replace-strict_strto-with-kstrto.patch
arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto.patch
arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto.patch
arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto.patch
arch-powerpc-replace-obsolete-strict_strto-calls.patch
arch-x86-replace-strict_strto-calls.patch
drivers-scsi-replace-strict_strto-calls.patch
net-sunrpc-replace-strict_strto-calls.patch
include-linux-remove-strict_strto-definitions.patch

