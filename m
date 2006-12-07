From: akpm@osdl.org
Subject: - remove-useless-carta_random32h.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:08:28 -0800
Message-ID: <200612072308.kB7N8Uji030420@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53498 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163885AbWLGXO7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:14:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eranian@hpl.hp.com, mm-commits@vger.kernel.org


The patch titled
     remove useless carta_random32.h
has been removed from the -mm tree.  Its filename was
     remove-useless-carta_random32h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove useless carta_random32.h
From: Stephane Eranian <eranian@hpl.hp.com>

Remove the carta_random32.h header file.  The carta_random32() function was
was put in and removed in favor of random32().  In the removal process, the
header file was forgotten.

Signed-off-by: Stephane Eranian <eranian@hpl.hp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/carta_random32.h |   29 -----------------------------
 1 file changed, 29 deletions(-)

diff -puN include/linux/carta_random32.h~remove-useless-carta_random32h /dev/null
--- a/include/linux/carta_random32.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * Fast, simple, yet decent quality random number generator based on
- * a paper by David G. Carta ("Two Fast Implementations of the
- * `Minimal Standard' Random Number Generator," Communications of the
- * ACM, January, 1990).
- *
- * Copyright (c) 2002-2006 Hewlett-Packard Development Company, L.P.
- *	Contributed by Stephane Eranian <eranian@hpl.hp.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of version 2 of the GNU General Public
- * License as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
- * 02111-1307 USA
- */
-#ifndef _LINUX_CARTA_RANDOM32_H_
-#define _LINUX_CARTA_RANDOM32_H_
-
-u64 carta_random32(u64 seed);
-
-#endif /* _LINUX_CARTA_RANDOM32_H_ */
_

Patches currently in -mm which might be from eranian@hpl.hp.com are

origin.patch

