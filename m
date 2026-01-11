Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACDD1A294
	for <mm-commits@vger.kernel.org>; Sun, 11 Jan 2026 01:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768096366; cv=none; b=gXNE367wX0XCF7f3xPN7TC0mPC5pE1C3ZiOhto88Pzwc3Gmj9znq8ImbYJUM5pKtFvb9WU5Azej3B/6FEGYwEzxWGErf6mPp4r45v8vywffD9xDfXoyHVnY62Swi3h6H9WXvbajVMfUy6D1lBFnjhAc35JpzzWCXBh8ALC1dwpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768096366; c=relaxed/simple;
	bh=4JYkr/MwhtVWKciiQaL/Cxelc9KlvDFPYInNmkzsKuo=;
	h=Date:To:From:Subject:Message-Id; b=ILDrY1JMdtu7lU6hWENIjbVhe/Ne2kkVZTa/d5LnBX9htFZRHHubjIIbti6og+pUn8NtagJ2krnFxnCyd77Lzs4E+yNV7HohupSpV0x84wchA2GhOVDPO/XBG/GT0D6FQ+yf/agz8q4LKwoOyqMp7IIKV8vKYRqfSeg4bVBk2pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=09FEdmwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="09FEdmwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F090C4CEF1;
	Sun, 11 Jan 2026 01:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768096365;
	bh=4JYkr/MwhtVWKciiQaL/Cxelc9KlvDFPYInNmkzsKuo=;
	h=Date:To:From:Subject:From;
	b=09FEdmwIQb67kh+3yY5Q9mPXMo1XP7Z98GZgAhS2IroRHoAnZ7socw/fs2/h9V161
	 O6RetPKNq3d5nZO5FsGEbOWflz3RaA+oXajNE9ZGxImtur4AeLvnHiyBTkwvfx5s3V
	 b8rGmTP2rzc6HRZ1hjqrQQ9/y2WOLcBCZ5rY2P6Y=
Date: Sat, 10 Jan 2026 17:52:45 -0800
To: mm-commits@vger.kernel.org,diego.viola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + credits-add-whitespace-before-opening-parentheses.patch added to mm-nonmm-unstable branch
Message-Id: <20260111015245.9F090C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: CREDITS: add whitespace before opening parentheses
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     credits-add-whitespace-before-opening-parentheses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/credits-add-whitespace-before-opening-parentheses.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Diego Viola <diego.viola@gmail.com>
Subject: CREDITS: add whitespace before opening parentheses
Date: Sat, 10 Jan 2026 21:23:52 -0300

In order to maintain consistent formatting across the file.

Link: https://lkml.kernel.org/r/20260111002353.4592-1-diego.viola@gmail.com
Signed-off-by: Diego Viola <diego.viola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/CREDITS~credits-add-whitespace-before-opening-parentheses
+++ a/CREDITS
@@ -695,7 +695,7 @@ S: USA
 N: Chih-Jen Chang
 E: chihjenc@scf.usc.edu
 E: chihjen@iis.sinica.edu.tw
-D: IGMP(Internet Group Management Protocol) version 2
+D: IGMP (Internet Group Management Protocol) version 2
 S: 3F, 65 Tajen street
 S: Tamsui town, Taipei county,
 S: Taiwan 251
@@ -1997,7 +1997,7 @@ E: bkaindl@netway.at
 E: edv@bartelt.via.at
 D: Author of a menu based configuration tool, kmenu, which
 D: is the predecessor of 'make menuconfig' and 'make xconfig'.
-D: digiboard driver update(modularisation work and 2.1.x upd)
+D: digiboard driver update (modularisation work and 2.1.x upd)
 S: Tallak 95
 S: 8103 Rein
 S: Austria
@@ -3609,7 +3609,7 @@ S: Finland
 N: Deepak Saxena
 E: dsaxena@plexity.net
 D: I2O kernel layer (config, block, core, pci, net). I2O disk support for LILO
-D: XScale(IOP, IXP) porting and other random ARM bits
+D: XScale (IOP, IXP) porting and other random ARM bits
 S: Portland, OR
 
 N: Eric Schenk
@@ -3986,7 +3986,7 @@ S: D-50968 Köln
 
 N: Tsu-Sheng Tsao
 E: tsusheng@scf.usc.edu
-D: IGMP(Internet Group Management Protocol) version 2
+D: IGMP (Internet Group Management Protocol) version 2
 S: 2F 14 ALY 31 LN 166 SEC 1 SHIH-PEI RD
 S: Taipei
 S: Taiwan 112
_

Patches currently in -mm which might be from diego.viola@gmail.com are

credits-add-whitespace-before-opening-parentheses.patch

