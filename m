From: akpm@linux-foundation.org
Subject: + uapi-remove-empty-kbuild-files.patch added to -mm tree
Date: Tue, 26 Mar 2013 13:19:35 -0700
Message-ID: <20130326201935.6CAC431C1C6@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:62633 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3CZUTh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 16:19:37 -0400
Received: by mail-gh0-f201.google.com with SMTP id r13so280131ghr.4
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 13:19:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     From: David Howells <dhowells@redhat.com>
has been added to the -mm tree.  Its filename is
     uapi-remove-empty-kbuild-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: UAPI: Remove empty Kbuild files

Remove empty Kbuild files as they cause problems with the patch program which
removes files that become empty.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/Kbuild      |    3 ---
 include/scsi/Kbuild |    1 -
 2 files changed, 4 deletions(-)

diff -puN include/Kbuild~uapi-remove-empty-kbuild-files include/Kbuild
--- a/include/Kbuild~uapi-remove-empty-kbuild-files
+++ a/include/Kbuild
@@ -1,5 +1,2 @@
 # Top-level Makefile calls into asm-$(ARCH)
 # List only non-arch directories below
-
-header-y += video/
-header-y += scsi/
diff -puN include/scsi/Kbuild~uapi-remove-empty-kbuild-files /dev/null
--- a/include/scsi/Kbuild
+++ /dev/null
@@ -1 +0,0 @@
-header-y += fc/
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
debug_locksh-make-warning-more-verbose.patch
mm-introduce-common-help-functions-to-deal-with-reserved-managed-pages.patch
mm-frv-use-common-help-functions-to-free-reserved-pages.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-frv-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-remove-free_area_cache.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch
uapi-remove-empty-kbuild-files.patch
mutex-subsystem-synchro-test-module.patch

