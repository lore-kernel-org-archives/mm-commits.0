From: akpm@linux-foundation.org
Subject: [patch 65/84] MAINTAINERS: add co-maintainer for scripts/gdb
Date: Mon, 23 May 2016 16:25:24 -0700
Message-ID: <57439164.jVlgCfc3VLiJGDzh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbcEWXZZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kieran@ksquared.org.uk, jan.kiszka@siemens.com

From: Kieran Bingham <kieran@bingham.xyz>
Subject: MAINTAINERS: add co-maintainer for scripts/gdb

Add myself as a co-maintainer for scripts/gdb supporting Jan Kizka

Link: http://lkml.kernel.org/r/fb5d34ce563f33d2f324f26f592b24ded30032ee.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-co-maintainer-for-scripts-gdb MAINTAINERS
--- a/MAINTAINERS~maintainers-add-co-maintainer-for-scripts-gdb
+++ a/MAINTAINERS
@@ -4859,6 +4859,7 @@ F:	drivers/scsi/gdt*
 
 GDB KERNEL DEBUGGING HELPER SCRIPTS
 M:	Jan Kiszka <jan.kiszka@siemens.com>
+M:	Kieran Bingham <kieran@bingham.xyz>
 S:	Supported
 F:	scripts/gdb/
 
_
