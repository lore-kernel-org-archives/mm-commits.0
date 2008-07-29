From: akpm@linux-foundation.org
Subject: + m32r-dont-offer-config_isa.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:24:40 -0700
Message-ID: <200807292224.m6TMOe0e024853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbYG2WY6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:24:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, takata@linux-m32r.org


The patch titled
     m32r: don't offer CONFIG_ISA
has been added to the -mm tree.  Its filename is
     m32r-dont-offer-config_isa.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r: don't offer CONFIG_ISA
From: Adrian Bunk <bunk@kernel.org>

As far as I know no M32R hardware actually has ISA slots.

And ISA drivers don't compile on M32R.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/Kconfig |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/m32r/Kconfig~m32r-dont-offer-config_isa arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~m32r-dont-offer-config_isa
+++ a/arch/m32r/Kconfig
@@ -406,11 +406,7 @@ config PCI_DIRECT
 source "drivers/pci/Kconfig"
 
 config ISA
-	bool "ISA support"
-	help
-	  Find out whether you have ISA slots on your motherboard.  ISA is the
-	  name of a bus system, i.e. the way the CPU talks to the other stuff
-	  inside your box.  If you have ISA, say Y, otherwise N.
+	bool
 
 source "drivers/pcmcia/Kconfig"
 
_

Patches currently in -mm which might be from bunk@kernel.org are

linux-next.patch
git-alsa-tiwai.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
git-security-testing.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

