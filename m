From: akpm@linux-foundation.org
Subject: [patch 03/13] MAINTAINERS: move the befs tree to kernel.org
Date: Fri, 14 Jul 2017 14:49:44 -0700
Message-ID: <59693c78.6Z1/5mpAbm231ryZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55736 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751178AbdGNVtp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:49:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, luisbg@kernel.org

From: Luis de Bethencourt <luisbg@kernel.org>
Subject: MAINTAINERS: move the befs tree to kernel.org

Update the location of the befs git tree and my email address.

Link: http://lkml.kernel.org/r/20170709110012.2991-1-luisbg@kernel.org
Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-move-the-befs-tree-to-kernelorg MAINTAINERS
--- a/MAINTAINERS~maintainers-move-the-befs-tree-to-kernelorg
+++ a/MAINTAINERS
@@ -2516,10 +2516,10 @@ S:	Supported
 F:	drivers/media/platform/sti/delta
 
 BEFS FILE SYSTEM
-M:	Luis de Bethencourt <luisbg@osg.samsung.com>
+M:	Luis de Bethencourt <luisbg@kernel.org>
 M:	Salah Triki <salah.triki@gmail.com>
 S:	Maintained
-T:	git git://github.com/luisbg/linux-befs.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/luisbg/linux-befs.git
 F:	Documentation/filesystems/befs.txt
 F:	fs/befs/
 
_
