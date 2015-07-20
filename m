From: akpm@linux-foundation.org
Subject: [merged] fs-proc-add-help-for-config_proc_children.patch removed
 from -mm tree
Date: Mon, 20 Jul 2015 11:49:52 -0700
Message-ID: <55ad42d0.zD2XmvRgBnI/30Le%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbbGTStx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jul 2015 14:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iago@endocode.com, jdelvare@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, proc: add help for CONFIG_PROC_CHILDREN
has been removed from the -mm tree.  Its filename was
     fs-proc-add-help-for-config_proc_children.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Iago L=F3pez Galeiras <iago@endocode.com>
Subject: fs, proc: add help for CONFIG_PROC_CHILDREN

The purpose of the option was documented in
Documentation/filesystems/proc.txt but the help text was missing.

Add small help text that also points to the documentation.

Signed-off-by: Iago L=F3pez Galeiras <iago@endocode.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Kconfig |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/proc/Kconfig~fs-proc-add-help-for-config_proc_children fs/=
proc/Kconfig
--- a/fs/proc/Kconfig~fs-proc-add-help-for-config_proc_children
+++ a/fs/proc/Kconfig
@@ -75,3 +75,9 @@ config PROC_PAGE_MONITOR
 config PROC_CHILDREN
 	bool "Include /proc/<pid>/task/<tid>/children file"
 	default n
+	help
+	  Provides a fast way to retrieve first level children pids of a task=
=2E See
+	  <file:Documentation/filesystems/proc.txt> for more information.
+
+	  Say Y if you are running any user-space software which takes benefi=
t from
+	  this interface. For example, rkt is such a piece of software.
_

Patches currently in -mm which might be from iago@endocode.com are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
