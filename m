From: akpm@linux-foundation.org
Subject: - aic7xxx-update-reg-files-update.patch removed from -mm tree
Date: Thu, 03 Jul 2008 23:46:19 -0700
Message-ID: <200807040646.m646kJw4017417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbYGDGq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 02:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, James.Bottomley@hansenpartnership.com, hare@suse.de, mm-commits@vger.kernel.org


The patch titled
     aic7xxx-update-reg-files update
has been removed from the -mm tree.  Its filename was
     aic7xxx-update-reg-files-update.patch

This patch was dropped because it was folded into aic7xxx-update-reg-files.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aic7xxx-update-reg-files update
From: Denys Vlasenko <vda.linux@googlemail.com>

On Tuesday 01 July 2008 18:52, Denys Vlasenko wrote:
> Update .reg files, marking unused registers with dont_generate_debug_code.
> Comment explains how to use it.

Some debugging comments were not removed from this patch.
Please, take this updated version of patch 2/3.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx.reg |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx.reg~aic7xxx-update-reg-files-update drivers/scsi/aic7xxx/aic79xx.reg
--- a/drivers/scsi/aic7xxx/aic79xx.reg~aic7xxx-update-reg-files-update
+++ a/drivers/scsi/aic7xxx/aic79xx.reg
@@ -495,7 +495,6 @@ register SG_CACHE_SHADOW {
 	field	ODD_SEG		0x04
 	field	LAST_SEG	0x02
 	field	LAST_SEG_DONE	0x01
-/*YAY*/
 }
 
 /*
@@ -2978,7 +2977,6 @@ register CCSCBCTL {
 	field	CCSCBEN		0x08
 	field	CCSCBDIR	0x04
 	field	CCSCBRESET	0x01
-/*YAY*/
 }
 
 /*
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

linux-next.patch
aic7xxx-introduce-dont_generate_debug_code-keyword-in-aicasm-parser.patch
aic7xxx-update-reg-files.patch
aic7xxx-update-reg-files-update.patch
aic7xxx-update-_shipped-files.patch
git-xfs.patch
fifo-pipe-reuse-xxx_fifo_fops-for-xxx_pipe_fops.patch

