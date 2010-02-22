From: akpm@linux-foundation.org
Subject: + doc-submitchecklist-add-rule-1.patch added to -mm tree
Date: Mon, 22 Feb 2010 12:47:15 -0800
Message-ID: <201002222047.o1MKlFIV022121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405Ab0BVUr2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 15:47:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au


The patch titled
     Documentation/SubmitChecklist: add rule #1
has been added to the -mm tree.  Its filename is
     doc-submitchecklist-add-rule-1.patch

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

linux-next.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
i2c-fix-xiic-build-error.patch
mfgpt-move-clocksource-menu.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch
documentation-timers-split-txt-and-source-files.patch
documentation-laptop-split-txt-and-source-files.patch
documentation-fs-split-txt-and-source-files.patch
documentation-vm-split-txt-and-source-files.patch
doc-submitchecklist-add-rule-1.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

