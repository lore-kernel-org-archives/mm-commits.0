From: akpm@linux-foundation.org
Subject: - uml-remove-unused-header.patch removed from -mm tree
Date: Tue, 13 May 2008 14:32:35 -0700
Message-ID: <200805132132.m4DLWZdC000701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760946AbYEMVc4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:32:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, bunk@kernel.org, jdike@linux.intel.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove unused header
has been removed from the -mm tree.  Its filename was
     uml-remove-unused-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: remove unused header
From: Jeff Dike <jdike@addtoit.com>


This patch removes the unused and broken (the normal asm/keyboard.h
files no longer exists) include/asm-um/keyboard.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/keyboard.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/asm-um/keyboard.h~uml-remove-unused-header /dev/null
--- a/include/asm-um/keyboard.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_KEYBOARD_H
-#define __UM_KEYBOARD_H
-
-#include "asm/arch/keyboard.h"
