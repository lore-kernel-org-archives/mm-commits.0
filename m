Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB6534D4F7
	for <mm-commits@vger.kernel.org>; Wed, 22 Oct 2025 18:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761158401; cv=none; b=tQeUBe/piTBnnCU+G2ueYWr6azF3jP5He4AjWNb0t/1Q4bjFsNyuC7v1G03Vex4luqJRgL/jhGk6WAauQmsecb+90IKfzx9s3OGBak/l6aZW63RLRuKDBajWgjEb1QU+9InhzJksIO8AWUiFFcnPeJ4XQ2HqjUmx4OWx+W2DI2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761158401; c=relaxed/simple;
	bh=YrfkhxV2ptK6bVLvDXWDTxKg56oE3k4gTSGzxi705Bg=;
	h=Date:To:From:Subject:Message-Id; b=RMyyjB+m/RIeKUFyK9O83Q+cmA8F05dmpQ44P+UvhMMOzX1o9zFp/Athh9UKTYgxMWMrIbhRHTCVXnf/oNRZFbBZ/LZbKLNbqcYsn3m5cn5vvhQmBwgty9Hb4U4CQr14QaEE8LZorTZvymPfki0nNv1LCDDm9rbhwwwGv38xm/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XJDmSQYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XJDmSQYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F40C4CEE7;
	Wed, 22 Oct 2025 18:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761158401;
	bh=YrfkhxV2ptK6bVLvDXWDTxKg56oE3k4gTSGzxi705Bg=;
	h=Date:To:From:Subject:From;
	b=XJDmSQYf8zA8PxRvFjnsw7g4BLCk/RQ9mge/D3fM7KlZ/Wwg5fZAQpvdzOu80OZWU
	 TskqWMSUNn7UFeJwBpaAYnh5GHxKJnWi1pTM/t31VJ+cLetVAZyYlrfDtmmcTBD9ek
	 vK/kAqPNhBLHmSWEJgSD6rRsSL8x+IGnB9nv/V7k=
Date: Wed, 22 Oct 2025 11:40:00 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,broonie@kernel.org,sfr@canb.auug.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mark-brown-as-a-maintainer.patch added to mm-hotfixes-unstable branch
Message-Id: <20251022184001.20F40C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Mark Brown as a linux-next maintainer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-mark-brown-as-a-maintainer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mark-brown-as-a-maintainer.patch

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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: MAINTAINERS: add Mark Brown as a linux-next maintainer
Date: Wed, 22 Oct 2025 16:36:25 +1100

Mark has been kindly helping fill in when I have been unavailable over the
past several years.  He has has also put his hand up to take over
linux-next maintenance when I finally decide to stop (which may be some
time yet ;-) ).

Link: https://lkml.kernel.org/r/20251022163625.5df7542a@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Mark Brown <broonie@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-mark-brown-as-a-maintainer
+++ a/MAINTAINERS
@@ -14393,6 +14393,7 @@ F:	tools/memory-model/
 
 LINUX-NEXT TREE
 M:	Stephen Rothwell <sfr@canb.auug.org.au>
+M:	Mark Brown <broonie@kernel.org>
 L:	linux-next@vger.kernel.org
 S:	Supported
 B:	mailto:linux-next@vger.kernel.org and the appropriate development tree
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

maintainers-add-mark-brown-as-a-maintainer.patch

