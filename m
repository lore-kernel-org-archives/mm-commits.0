From: akpm@linux-foundation.org
Subject: - use-data_data-in-cris.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:09:28 -0700
Message-ID: <200707172309.l6HN9SH6012371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45715 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936301AbXGQXPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, dev-etrax@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: use DATA_DATA
has been removed from the -mm tree.  Its filename was
     use-data_data-in-cris.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris: use DATA_DATA
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: <starvik@axis.com>
Cc: <dev-etrax@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/vmlinux.lds.S |    2 +-
 arch/cris/arch-v32/vmlinux.lds.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/cris/arch-v10/vmlinux.lds.S~use-data_data-in-cris arch/cris/arch-v10/vmlinux.lds.S
--- a/arch/cris/arch-v10/vmlinux.lds.S~use-data_data-in-cris
+++ a/arch/cris/arch-v10/vmlinux.lds.S
@@ -44,7 +44,7 @@ SECTIONS
 	___data_start = . ;
 	__Sdata = . ;
 	.data : {                     /* Data */
-		*(.data)
+		DATA_DATA
 	}
 	__edata = . ;                 /* End of data section */
 	_edata = . ;
diff -puN arch/cris/arch-v32/vmlinux.lds.S~use-data_data-in-cris arch/cris/arch-v32/vmlinux.lds.S
--- a/arch/cris/arch-v32/vmlinux.lds.S~use-data_data-in-cris
+++ a/arch/cris/arch-v32/vmlinux.lds.S
@@ -49,7 +49,7 @@ SECTIONS
 	___data_start = . ;
 	__Sdata = . ;
 	.data : {                     /* Data */
-		*(.data)
+		DATA_DATA
 	}
 	__edata = . ;		/* End of data section. */
 	_edata = . ;
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-kbuild.patch
