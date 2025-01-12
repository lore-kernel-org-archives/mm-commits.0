Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1727F8F58
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 01:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736645545; cv=none; b=X8HxFlR40urU+5eaGH6kIvI6Ex0JB8CoxEsaAzAMe8iFCjKZ+dQhK2KxnMwqvOdah7h8Rc7fYihfH7N1RWdZ+eWAxfI6q90t3vcChdxG/DNq+kE3BGIXOgPGX9h5w239QH650J5wRaHp0T92UmJpNxNXe7vI9xGoqOhvsYqFeQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736645545; c=relaxed/simple;
	bh=ItDhm28KSW7efKWW8ZDcu/+uc/VIAyMV3McHWcV2ykI=;
	h=Date:To:From:Subject:Message-Id; b=a0r+mjTuGGUi0Eez2khwm+srObgMIpOf4ywLxPPh10qdUklxQhfmEzfl4ItqA6VZsPAYm8YQHCVzGsQVvNyY1ry1kLZXUXLF4BNnG6wVL2aRI8sx8XFO/ddy8FS/HP48nKT5XdpMiD0AvQ90yjqUHlxc3TCS3kXD1Q+FWkKFIYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EKynz48T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EKynz48T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED9AC4CED2;
	Sun, 12 Jan 2025 01:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736645544;
	bh=ItDhm28KSW7efKWW8ZDcu/+uc/VIAyMV3McHWcV2ykI=;
	h=Date:To:From:Subject:From;
	b=EKynz48TP3I9RrTRlVkMqCKNs6f52mDlkc+tPe0fST8h8nPlDg3U3K4qM2VPXIsE1
	 VxajpdobE6R46n8wHR1/xeSQuTohxjZ0X85gk1Ymsz+bmpRgTXUlE53xOrLyaT+8fw
	 Cxn7+X1O8e6yGWdtlHo+uDV8oDENtjnTYVHgDhsA=
Date: Sat, 11 Jan 2025 17:32:23 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,carlos.bilbao@kernel.org,avadhut.naik@amd.com,carlos.bilbao.osdev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-docs-update-email-to-carlosbilbao-kernelorg.patch added to mm-hotfixes-unstable branch
Message-Id: <20250112013224.6ED9AC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap, docs: update email to carlos.bilbao@kernel.org
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-docs-update-email-to-carlosbilbao-kernelorg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-docs-update-email-to-carlosbilbao-kernelorg.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
Subject: mailmap, docs: update email to carlos.bilbao@kernel.org
Date: Sat, 11 Jan 2025 10:11:06 -0600

Update .mailmap to reflect my new (and final) primary email address,
carlos.bilbao@kernel.org.  This ensures consistent attribution in Git
history.  Also update my contact information in file
Documentation/translations/sp_SP/index.rst to help contributors reach out
for Spanish translations.

Link: https://lkml.kernel.org/r/20250111161110.862131-1-carlos.bilbao@kernel.org
Signed-off-by: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Avadhut Naik <avadhut.naik@amd.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                                   |    3 +++
 Documentation/translations/sp_SP/index.rst |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/Documentation/translations/sp_SP/index.rst~mailmap-docs-update-email-to-carlosbilbao-kernelorg
+++ a/Documentation/translations/sp_SP/index.rst
@@ -7,7 +7,7 @@ Traducción al español
 
 	\kerneldocCJKoff
 
-:maintainer: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
+:maintainer: Carlos Bilbao <carlos.bilbao@kernel.org>
 
 .. _sp_disclaimer:
 
--- a/.mailmap~mailmap-docs-update-email-to-carlosbilbao-kernelorg
+++ a/.mailmap
@@ -140,6 +140,9 @@ Cai Huoqing <cai.huoqing@linux.dev> <cai
 Can Guo <quic_cang@quicinc.com> <cang@codeaurora.org>
 Carl Huang <quic_cjhuang@quicinc.com> <cjhuang@codeaurora.org>
 Carlos Bilbao <carlos.bilbao.osdev@gmail.com> <carlos.bilbao@amd.com>
+Carlos Bilbao <carlos.bilbao@kernel.org> <carlos.bilbao.osdev@gmail.com>
+Carlos Bilbao <carlos.bilbao@kernel.org> <carlos.bilbao@amd.com>
+Carlos Bilbao <carlos.bilbao@kernel.org> <bilbao@vt.edu>
 Changbin Du <changbin.du@intel.com> <changbin.du@gmail.com>
 Changbin Du <changbin.du@intel.com> <changbin.du@intel.com>
 Chao Yu <chao@kernel.org> <chao2.yu@samsung.com>
_

Patches currently in -mm which might be from carlos.bilbao.osdev@gmail.com are

mailmap-docs-update-email-to-carlosbilbao-kernelorg.patch

