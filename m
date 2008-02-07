From: akpm@linux-foundation.org
Subject: + docbook-dmapool-fix-fatal-changed-filename.patch added to -mm tree
Date: Wed, 06 Feb 2008 16:58:15 -0800
Message-ID: <200802070058.m170wFt2008689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757594AbYBGA67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:58:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, willy@debian.org


The patch titled
     docbook: dmapool: fix fatal changed filename
has been added to the -mm tree.  Its filename is
     docbook-dmapool-fix-fatal-changed-filename.patch

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
Subject: docbook: dmapool: fix fatal changed filename
From: Randy Dunlap <randy.dunlap@oracle.com>

Docbook fatal error, file was moved:
docproc: linux-2.6.24-git15/drivers/base/dmapool.c: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~docbook-dmapool-fix-fatal-changed-filename Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~docbook-dmapool-fix-fatal-changed-filename
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -165,6 +165,7 @@ X!Ilib/string.c
 !Emm/vmalloc.c
 !Imm/page_alloc.c
 !Emm/mempool.c
+!Emm/dmapool.c
 !Emm/page-writeback.c
 !Emm/truncate.c
      </sect1>
@@ -371,7 +372,6 @@ X!Iinclude/linux/device.h
 !Edrivers/base/class.c
 !Edrivers/base/firmware_class.c
 !Edrivers/base/transport_class.c
-!Edrivers/base/dmapool.c
 <!-- Cannot be included, because
      attribute_container_add_class_device_adapter
  and attribute_container_classdev_to_container
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
docbook-dmapool-fix-fatal-changed-filename.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
