From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-define-maintainer.patch removed from -mm
 tree
Date: Wed, 18 Feb 2015 11:44:46 -0800
Message-ID: <54e4ebae.iVRj2uQ8ZBF+sIiR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbbBRTor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: define maintainer
has been removed from the -mm tree.  Its filename was
     scripts-gdb-define-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: define maintainer

I'm proposing myself for keeping an eye on these scripts and integrating
contributions.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN MAINTAINERS~scripts-gdb-define-maintainer MAINTAINERS
--- a/MAINTAINERS~scripts-gdb-define-maintainer
+++ a/MAINTAINERS
@@ -4232,6 +4232,11 @@ W:	http://www.icp-vortex.com/
 S:	Supported
 F:	drivers/scsi/gdt*
 
+GDB KERNEL DEBUGGING HELPER SCRIPTS
+M:	Jan Kiszka <jan.kiszka@siemens.com>
+S:	Supported
+F:	scripts/gdb/
+
 GEMTEK FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

