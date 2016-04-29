From: akpm@linux-foundation.org
Subject: + nilfs2-clarify-permission-to-replicate-the-design.patch added
 to -mm tree
Date: Fri, 29 Apr 2016 13:40:25 -0700
Message-ID: <5723c6b9.0QEBNcrYf633JBjT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbcD2Uk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 16:40:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: clarify permission to replicate the design
has been added to the -mm tree.  Its filename is
     nilfs2-clarify-permission-to-replicate-the-design.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-clarify-permission-to-replicate-the-design.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-clarify-permission-to-replicate-the-design.patch

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
Subject: nilfs2: clarify permission to replicate the design

To respond to a certain developer's request, this explicitly state
that developers can reimplement the nilfs2 design for other operating
systems to share data stored in that format.

Link: http://lkml.kernel.org/r/1461935747-10380-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/nilfs2.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN Documentation/filesystems/nilfs2.txt~nilfs2-clarify-permission-to-replicate-the-design Documentation/filesystems/nilfs2.txt
--- a/Documentation/filesystems/nilfs2.txt~nilfs2-clarify-permission-to-replicate-the-design
+++ a/Documentation/filesystems/nilfs2.txt
@@ -268,3 +268,8 @@ among NILFS2 files can be depicted as fo
                                     ( regular file, directory, or symlink )
 
 For detail on the format of each file, please see include/linux/nilfs2_fs.h.
+
+There are no patents or other intellectual property that we protect
+with regard to the design of NILFS2.  It is allowed to replicate the
+design in hopes that other operating systems could share (mount, read,
+write, etc.) data stored in this format.
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-fix-white-space-issue-in-nilfs_mount.patch
nilfs2-remove-space-before-comma.patch
nilfs2-remove-fsf-mailing-address-from-gpl-notices.patch
nilfs2-clean-up-old-e-mail-addresses.patch
maintainers-add-web-link-for-nilfs-project.patch
nilfs2-clarify-permission-to-replicate-the-design.patch
nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty.patch
nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines.patch
nilfs2-replace-__attribute__packed-with-__packed.patch
nilfs2-add-missing-line-spacing.patch
nilfs2-clean-trailing-semicolons-in-macros.patch

