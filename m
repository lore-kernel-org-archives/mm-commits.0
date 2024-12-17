Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C433C8615A
	for <mm-commits@vger.kernel.org>; Tue, 17 Dec 2024 18:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458769; cv=none; b=leBfMDoSpiDLsLhQwrQRZ7swHCDaAfGP8H6vbPGmXyjdNMZQouja1qvNeXLwnGQ+EcW1Pj+Lm52MUSDQ1YVPQ4IWvANOTIFT5I1rPtE1bTvZhN7RE/euCOdXkY6RQjenR8qOdCXuPxBhHdsmls423DIzUVrWCw3CzRRkAVcc3aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458769; c=relaxed/simple;
	bh=9NAf96pFiEEXk8diuHENuFPj3HevXWcp5AcK5OTCrRU=;
	h=Date:To:From:Subject:Message-Id; b=WmUgLszB/4lI5fZpsbe6kRIRfisqX++8DKLQhRIV2KoomDc84itHfPzxeX5wewXIQouy86twQjuPKHu67jTye5FXjEfqIXTMys1mG1Zb+OjL6XL2rhEgvXRQMBy559Bkf2F7tXPSrF3FP6KvDeULl/Tszk30lUPqlrWQC+84Ujo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1NIUtllm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1NIUtllm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D17C4CED3;
	Tue, 17 Dec 2024 18:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734458769;
	bh=9NAf96pFiEEXk8diuHENuFPj3HevXWcp5AcK5OTCrRU=;
	h=Date:To:From:Subject:From;
	b=1NIUtllmkEdxqM/RFgdwwoAX6/ccJJTYwVHhXSZ1VzeGnhh+c0LtSWM5M9d7+RsN2
	 P+b5GAPu5Yalz3zcxFzOymsh7cOWTi/uCX+kxu7PvOhtPW2Ug6bavv80DklvRkkiI8
	 fUF81mKhPK69XSIE7EMNBNHN79xMclJ7Y1MM5wH4=
Date: Tue, 17 Dec 2024 10:06:08 -0800
To: mm-commits@vger.kernel.org,qmo@kernel.org,neeraj.upadhyay@kernel.org,matttbe@kernel.org,kees@kernel.org,geliang@kernel.org,elder@kernel.org,davem@davemloft.net,othacehe@gnu.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-modify-the-entry-for-mathieu-othacehe.patch added to mm-hotfixes-unstable branch
Message-Id: <20241217180609.42D17C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: modify the entry for Mathieu Othacehe
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-modify-the-entry-for-mathieu-othacehe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-modify-the-entry-for-mathieu-othacehe.patch

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
From: Mathieu Othacehe <othacehe@gnu.org>
Subject: mailmap: modify the entry for Mathieu Othacehe
Date: Tue, 17 Dec 2024 11:09:21 +0100

Set my gnu address as the main one.

Link: https://lkml.kernel.org/r/20241217100924.7821-1-othacehe@gnu.org
Signed-off-by: Mathieu Othacehe <othacehe@gnu.org>
Cc: Alex Elder <elder@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geliang Tang <geliang@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Cc: Quentin Monnet <qmo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/.mailmap~mailmap-modify-the-entry-for-mathieu-othacehe
+++ a/.mailmap
@@ -435,7 +435,7 @@ Martin Kepplinger <martink@posteo.de> <m
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@puri.sm>
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@theobroma-systems.com>
 Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com> <martyna.szapar-mudlaw@intel.com>
-Mathieu Othacehe <m.othacehe@gmail.com> <othacehe@gnu.org>
+Mathieu Othacehe <othacehe@gnu.org> <m.othacehe@gmail.com>
 Mat Martineau <martineau@kernel.org> <mathew.j.martineau@linux.intel.com>
 Mat Martineau <martineau@kernel.org> <mathewm@codeaurora.org>
 Matthew Wilcox <willy@infradead.org> <matthew.r.wilcox@intel.com>
_

Patches currently in -mm which might be from othacehe@gnu.org are

mailmap-modify-the-entry-for-mathieu-othacehe.patch

