From: akpm@linux-foundation.org
Subject: [merged] nilfs2-clarify-permission-to-replicate-the-design.patch
 removed from -mm tree
Date: Fri, 27 May 2016 11:42:50 -0700
Message-ID: <5748952a.q20XaaRk8DO3wgJn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbcE0Smv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:42:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: clarify permission to replicate the design
has been removed from the -mm tree.  Its filename was
     nilfs2-clarify-permission-to-replicate-the-design.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


