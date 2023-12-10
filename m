Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E48134B2
	for <mm-commits@vger.kernel.org>; Sun, 10 Dec 2023 18:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vZhFBMbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBD9C433C7;
	Sun, 10 Dec 2023 18:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702233066;
	bh=BzhVFLft7yXKtuVBRhso5qrkBsL6VAZb1hT+gO/XMzc=;
	h=Date:To:From:Subject:From;
	b=vZhFBMbDAAqCqN6+sH1cc/1PEeXHgX/Gsn/phRge+IvIYZjnrVyfkt8JRIAd2PtZm
	 H51wbGjbzqSziANZSMiRfjyhOmOJ328ZO3m2pPN0L7+5SeR83dy8Pv9YV4ikAhQ4uu
	 tTYxExAeC23aUNA3rQrjs+lbLaQY9NaYFZIcQN5E=
Date: Sun, 10 Dec 2023 10:31:05 -0800
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,klondike@klondike.es,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + usr-kconfig-fix-typos-of-its.patch added to mm-nonmm-unstable branch
Message-Id: <20231210183106.7EBD9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: usr/Kconfig: fix typos of "its"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     usr-kconfig-fix-typos-of-its.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/usr-kconfig-fix-typos-of-its.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: usr/Kconfig: fix typos of "its"
Date: Sat, 9 Dec 2023 21:34:29 -0800

Use "Its" or "its" for possessive instead of "it's" (contraction
for "it is").

Link: https://lkml.kernel.org/r/20231210053429.23146-1-rdunlap@infradead.org
Fixes: db2aa7fd15e8 ("initramfs: allow again choice of the embedded initram compression algorithm")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: "Francisco Blas Izquierdo Riera (klondike)" <klondike@klondike.es>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/usr/Kconfig~usr-kconfig-fix-typos-of-its
+++ a/usr/Kconfig
@@ -185,9 +185,9 @@ config INITRAMFS_COMPRESSION_LZO
 	bool "LZO"
 	depends on RD_LZO
 	help
-	  It's compression ratio is the second poorest amongst the choices. The
-	  kernel size is about 10% bigger than gzip. Despite that, it's
-	  decompression speed is the second fastest and it's compression speed
+	  Its compression ratio is the second poorest amongst the choices. The
+	  kernel size is about 10% bigger than gzip. Despite that, its
+	  decompression speed is the second fastest and its compression speed
 	  is quite fast too.
 
 	  If you choose this, keep in mind that you may need to install the lzop
_

Patches currently in -mm which might be from rdunlap@infradead.org are

rapidio-tsi721-fix-kernel-doc-warnings.patch
freevxfs-bmap-fix-kernel-doc-warnings.patch
freevxfs-immed-fix-kernel-doc-param-name.patch
freevxfs-lookup-fix-function-params-kernel-doc.patch
init-kconfig-move-more-items-into-the-expert-menu.patch
usr-kconfig-fix-typos-of-its.patch

