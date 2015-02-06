From: akpm@linux-foundation.org
Subject: [merged]
 mailmap-update-konstantin-khlebnikovs-email-address.patch removed from -mm
 tree
Date: Fri, 06 Feb 2015 14:02:29 -0800
Message-ID: <54d539f5.Y3cV/N8cEZCdEdcN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53253 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbBFWCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2015 17:02:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kim.phillips@freescale.com, koct9i@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: .mailmap: update Konstantin Khlebnikov's email address
has been removed from the -mm tree.  Its filename was
     mailmap-update-konstantin-khlebnikovs-email-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kim Phillips <kim.phillips@freescale.com>
Subject: .mailmap: update Konstantin Khlebnikov's email address

get_maintainer.pl returns k.khlebnikov@samsung.com via git history,
for which emails get rejected:

 RCPT TO:<k.khlebnikov@samsung.com>
 550 5.1.1 Recipient address rejected: User unknown

Use his other address that passes vger's mxverify:

 RCPT TO:<koct9i@gmail.com>
 250 2.1.5 OK ir10si13843754pbc.62 - gsmtp

and add his old email address in the wrong email address field.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
Acked-by: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

diff -puN .mailmap~mailmap-update-konstantin-khlebnikovs-email-address .mailmap
--- a/.mailmap~mailmap-update-konstantin-khlebnikovs-email-address
+++ a/.mailmap
@@ -73,6 +73,7 @@ Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
 Kay Sievers <kay.sievers@vrfy.org>
 Kenneth W Chen <kenneth.w.chen@intel.com>
+Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
 Koushik <raghavendra.koushik@neterion.com>
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
_

Patches currently in -mm which might be from kim.phillips@freescale.com are

origin.patch
mm-slub-fix-typo.patch
linux-next.patch

