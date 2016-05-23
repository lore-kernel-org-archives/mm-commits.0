From: akpm@linux-foundation.org
Subject: [patch 18/84] MAINTAINERS: add web link for nilfs project
Date: Mon, 23 May 2016 16:23:11 -0700
Message-ID: <574390df./5YZqwuFAUnCcSY9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcEWXXN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:23:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: MAINTAINERS: add web link for nilfs project

Add nilfs.osdn.jp as the second web site of nilfs project.

Link: http://lkml.kernel.org/r/1461935747-10380-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-web-link-for-nilfs-project MAINTAINERS
--- a/MAINTAINERS~maintainers-add-web-link-for-nilfs-project
+++ a/MAINTAINERS
@@ -7900,6 +7900,7 @@ NILFS2 FILESYSTEM
 M:	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
 L:	linux-nilfs@vger.kernel.org
 W:	http://nilfs.sourceforge.net/
+W:	http://nilfs.osdn.jp/
 T:	git git://github.com/konis/nilfs2.git
 S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
_
