From: akpm@linux-foundation.org
Subject: - e1000e-remove-unnecessary-snippet-missed-in-prior-check_options-update.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:54:38 -0700
Message-ID: <200808142354.m7ENsc82003956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbYHNXyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:54:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000e: remove unnecessary snippet missed in prior check_options update
has been removed from the -mm tree.  Its filename was
     e1000e-remove-unnecessary-snippet-missed-in-prior-check_options-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: remove unnecessary snippet missed in prior check_options update
From: Bruce Allan <bruce.w.allan@intel.com>

The removal of this bit of code was missed in an earlier patch submittal.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/param.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/net/e1000e/param.c~e1000e-remove-unnecessary-snippet-missed-in-prior-check_options-update drivers/net/e1000e/param.c
--- a/drivers/net/e1000e/param.c~e1000e-remove-unnecessary-snippet-missed-in-prior-check_options-update
+++ a/drivers/net/e1000e/param.c
@@ -324,8 +324,6 @@ void __devinit e1000e_check_options(stru
 				adapter->itr = 20000;
 				break;
 			default:
-				e1000_validate_option(&adapter->itr, &opt,
-					adapter);
 				/*
 				 * Save the setting, because the dynamic bits
 				 * change itr.
_

Patches currently in -mm which might be from bruce.w.allan@intel.com are

git-net.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch

