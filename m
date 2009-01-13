From: akpm@linux-foundation.org
Subject: + sysrq-documentation-remove-the-redundant-updated-date.patch added to -mm tree
Date: Mon, 12 Jan 2009 20:18:50 -0800
Message-ID: <200901130418.n0D4Io7r004635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbZAMES6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 23:18:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, randy.dunlap@oracle.com


The patch titled
     sysrq documentation: remove the redundant updated date
has been added to the -mm tree.  Its filename is
     sysrq-documentation-remove-the-redundant-updated-date.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysrq documentation: remove the redundant updated date
From: Andy Whitcroft <apw@canonical.com>

git is maintaining the last update time much more accuratly than the
internal update time.  Remove it.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |    1 -
 1 file changed, 1 deletion(-)

diff -puN Documentation/sysrq.txt~sysrq-documentation-remove-the-redundant-updated-date Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~sysrq-documentation-remove-the-redundant-updated-date
+++ a/Documentation/sysrq.txt
@@ -1,6 +1,5 @@
 Linux Magic System Request Key Hacks
 Documentation for sysrq.c
-Last update: 2007-AUG-04
 
 *  What is the magic SysRq key?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_

Patches currently in -mm which might be from apw@canonical.com are

mmc-add-modalias-linkage-for-mmc-sd-devices.patch
sysrq-documentation-remove-the-redundant-updated-date.patch
sysrq-documentation-document-why-the-command-header-only-is-shown.patch
sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg.patch

