From: akpm@linux-foundation.org
Subject: + nilfs2-fix-code-indent-coding-style-issue.patch added to -mm
 tree
Date: Tue, 10 May 2016 12:23:45 -0700
Message-ID: <57323541.tiQpJlaLlFyZmv6a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbcEJTXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:23:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix code indent coding style issue
has been added to the -mm tree.  Its filename is
     nilfs2-fix-code-indent-coding-style-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-code-indent-coding-style-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-code-indent-coding-style-issue.patch

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
Subject: nilfs2: fix code indent coding style issue

This fixes checkpatch.pl warning "WARNING: suspect code indent for
conditional statements".

Link: http://lkml.kernel.org/r/1462886671-3521-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/super.c~nilfs2-fix-code-indent-coding-style-issue fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-fix-code-indent-coding-style-issue
+++ a/fs/nilfs2/super.c
@@ -273,7 +273,7 @@ struct nilfs_super_block **nilfs_prepare
 		}
 	} else if (sbp[1] &&
 		   sbp[1]->s_magic != cpu_to_le16(NILFS_SUPER_MAGIC)) {
-			memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
+		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
 	}
 
 	if (flip && sbp[1])
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
nilfs2-clean-trailing-semicolons-in-macros-fix.patch
nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error.patch
nilfs2-remove-space-before-semicolon.patch
nilfs2-fix-code-indent-coding-style-issue.patch
nilfs2-avoid-bare-use-of-unsigned.patch
nilfs2-remove-unnecessary-else-after-return-or-break.patch
nilfs2-remove-loops-of-single-statement-macros.patch
nilfs2-fix-block-comments.patch

