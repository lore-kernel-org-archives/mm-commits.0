Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84E220B20
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 04:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736309324; cv=none; b=BGycbK8KW8oJtyWVu3JdenAviiBYta1QUwswqLBqtK9HxBzKP4+GzSqcH09i/Yb1bSvKLlZpzObyc1eP9qK0DaKlwr8VKuTA7Unf04QKFaU8Zt/wClxPAa+upDJPBYkp4ukXGgqpeTJkAwD7AFfXK8Uob8zchmyMlT8/3HbaPoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736309324; c=relaxed/simple;
	bh=5Ih7oTV6jJUUJ3LK4sLAOGI0v6YoTGyVk2WIgrJ5AeM=;
	h=Date:To:From:Subject:Message-Id; b=TxqXx45QMoxjCjoRqAXz9+KTrKPA0+nB5BNtY1a6XWqXe2XWVjPfVp4rsZbn+ZnrbqgoEUUrqec1AJFUbQfLze4hW3mMrq8jdZyDh7PvgQId5aLFA25zCqwd3jU3Jj9+W1PZiHHWwDJH+cHd0Z7Bj9qGRmWEhTDe2TynixzHXPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Epb/WbDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Epb/WbDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604A2C4CED0;
	Wed,  8 Jan 2025 04:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736309324;
	bh=5Ih7oTV6jJUUJ3LK4sLAOGI0v6YoTGyVk2WIgrJ5AeM=;
	h=Date:To:From:Subject:From;
	b=Epb/WbDhhDPtDJixL8loZ1Sw9EdN03hP1w7zdUa7B8Jnyx6WoyWls8grARlkDzWYi
	 l5VsIvBZUxs9SUsTktAoLoUaVtgcul7gDP+oRbG3US89mX3PwvSJMDwcfX8mEuGXLo
	 8k3AaTf7O2lUbmcX5/u1D9opux7My5mPyq9fBQq8=
Date: Tue, 07 Jan 2025 20:08:43 -0800
To: mm-commits@vger.kernel.org,linus.luessing@c0d3.blue,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-entry-for-linus-lüssing.patch added to mm-nonmm-unstable branch
Message-Id: <20250108040844.604A2C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update entry for Linus Lüssing
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-entry-for-linus-lüssing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-entry-for-linus-lüssing.patch

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
From: Linus Lüssing <linus.luessing@c0d3.blue>
Subject: mailmap: update entry for Linus Lüssing
Date: Wed, 8 Jan 2025 04:58:39 +0100

Mapping another old, obsolete work email address to my primary one.

Link: https://lkml.kernel.org/r/20250108035840.25194-1-linus.luessing@c0d3.blue
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-entry-for-linus-lüssing
+++ a/.mailmap
@@ -405,6 +405,7 @@ Liam Mark <quic_lmark@quicinc.com> <lmar
 Linas Vepstas <linas@austin.ibm.com>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@web.de>
+Linus Lüssing <linus.luessing@c0d3.blue> <ll@simonwunderlich.de>
 <linux-hardening@vger.kernel.org> <kernel-hardening@lists.openwall.com>
 Li Yang <leoyang.li@nxp.com> <leoli@freescale.com>
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
_

Patches currently in -mm which might be from linus.luessing@c0d3.blue are

mailmap-update-entry-for-linus-lüssing.patch

