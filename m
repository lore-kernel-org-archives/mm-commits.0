From: akpm@linux-foundation.org
Subject: [merged] doc-submitchecklist-add-rule-1.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:57:55 -0400
Message-ID: <201003150658.o2F6wSOZ016450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935700Ab0COG6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Documentation/SubmitChecklist: add rule #1
has been removed from the -mm tree.  Its filename was
     doc-submitchecklist-add-rule-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/SubmitChecklist: add rule #1
From: Randy Dunlap <randy.dunlap@oracle.com>

Add header file requirements.  Compliments of Stephen Rothwell.

Stephen calls this Rule #1, so I put it there, but I didn't want to demote
any of the others in the list, so I made one of them number 2b.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN Documentation/SubmitChecklist~doc-submitchecklist-add-rule-1 Documentation/SubmitChecklist
--- a/Documentation/SubmitChecklist~doc-submitchecklist-add-rule-1
+++ a/Documentation/SubmitChecklist
@@ -9,10 +9,14 @@ Documentation/SubmittingPatches and else
 kernel patches.
 
 
-1: Builds cleanly with applicable or modified CONFIG options =y, =m, and
+1: If you use a facility then #include the file that defines/declares
+   that facility.  Don't depend on other header files pulling in ones
+   that you use.
+
+2: Builds cleanly with applicable or modified CONFIG options =y, =m, and
    =n.  No gcc warnings/errors, no linker warnings/errors.
 
-2: Passes allnoconfig, allmodconfig
+2b: Passes allnoconfig, allmodconfig
 
 3: Builds on multiple CPU architectures by using local cross-compile tools
    or some other build farm.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

