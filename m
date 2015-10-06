From: akpm@linux-foundation.org
Subject: + maintainers-nilfs2-add-header-file-for-tracing.patch added to
 -mm tree
Date: Tue, 06 Oct 2015 13:03:41 -0700
Message-ID: <5614291d.ApdTCUOCZtDR8N+c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbbJFUDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2015 16:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mitake.hitoshi@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: nilfs2: add header file for tracing
has been added to the -mm tree.  Its filename is
     maintainers-nilfs2-add-header-file-for-tracing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-nilfs2-add-header-file-for-tracing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-nilfs2-add-header-file-for-tracing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: MAINTAINERS: nilfs2: add header file for tracing

This adds header file "include/trace/events/nilfs2.h" to maintainer-ship
of nilfs2 so that updates to the nilfs2 header file go to the mailing list
of nilfs2.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-nilfs2-add-header-file-for-tracing MAINTAINERS
--- a/MAINTAINERS~maintainers-nilfs2-add-header-file-for-tracing
+++ a/MAINTAINERS
@@ -7371,6 +7371,7 @@ S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
 F:	fs/nilfs2/
 F:	include/linux/nilfs2_fs.h
+F:	include/trace/events/nilfs2.h
 
 NINJA SCSI-3 / NINJA SCSI-32Bi (16bit/CardBus) PCMCIA SCSI HOST ADAPTER DRIVER
 M:	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-use-nilfs_warning-in-allocator-implementation.patch
nilfs2-do-not-call-nilfs_mdt_bgl_lock-needlessly.patch
nilfs2-refactor-nilfs_palloc_find_available_slot.patch
nilfs2-get-rid-of-nilfs_palloc_group_is_in.patch
nilfs2-add-helper-functions-to-delete-blocks-from-dat-file.patch
nilfs2-free-unused-dat-file-blocks-during-garbage-collection.patch
maintainers-nilfs2-add-header-file-for-tracing.patch

