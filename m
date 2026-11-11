Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794372208;
	b=L8f2BJWkdbbVDYMhKCQbav9zN8ih07T6lbVBk5Zzk1OVwe61oHk0mio3zUAbVcLvtaDc
	 LYNYKdI67vnJTH3DkAzqVMpJRbFpGubCFGMuMcqCOR7Ss6I04tXhZm77tDK3NaOuaKErK
	 wi/wc0v1hgkQivTIJReWYu77hEqtuJIG1UXn+pddAkSkkFA5oTNsxoM5G9v/xKqDwBLzK
	 u9+wdBlM487+6z7OioUa3B48xGKtsaFcG+xFhvr8K3WJPkish5jv5AkkcHFtAwPGEkEB6
	 yGCU7ENWqozPcZ8FfKbDO/XlWcxCy0cZx81Dv9Mvyb6HrKtYxqendV5eDp1lGljf/qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794372208;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=J3IKk3IdDN0w8r1FRHyg9ZWrTB1Q2g64CtJJT11usJ8=;
	b=U+Y9azpyEulE5WjL4ZRQeFw5119CMQUShZao53qopypHwqH26ZvmWdQfmmPcmwAfPD85
	 /RpUc5FdeHze+dgr7cHW0CkmwCrocMkzpTd4lBV6sVA3e/ZrffQkcm/Vr8Gkb7oIkBIw1
	 dDDQaFfKGSW0qy5i5YGBrnbCcveYmtlPeXgIj+pIK59/f0vDk0CCA3MDoHVZ7zcNzdnMi
	 P4IvXq9WqWMAEwhN+2/TCIG2XTNxWgWyDE34tlyj11qJvZExF889Q2pxlqzGHn1hN0tlA
	 6FGEExMORG1kggeAGU9lRokzLcYAfneEfVHTduWR92JJqmb6JHOo38pFkluoqgfumXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NNA1MrmW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2AE606A31C
	for <mm-commits@vger.kernel.org>; Wed, 11 Nov 2026 04:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NNA1MrmW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234CD1F0089F;
	Wed, 11 Nov 2026 04:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794372208;
	bh=J3IKk3IdDN0w8r1FRHyg9ZWrTB1Q2g64CtJJT11usJ8=;
	h=Date:To:From:Subject;
	b=NNA1MrmWBnYm/OQT9wESzjG+/puw4WqIZ1omnPBkkfqj3ux52ZgU4lMxqTXJffBns
	 EJF6iiuhdIpMs+LWdlvtmIdSJ3szJKI2AJLT2/GagDJll4mF1eluBRhGj3afDMAvai
	 uwiVIyDtUIle1bqMoRLsSMbVwE7VVO9G0K306Ej0=
Date: Tue, 10 Nov 2026 20:43:27 -0800
To: mm-commits@vger.kernel.org,guodong.xu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-entry-for-guodong-xu.patch added to mm-nonmm-unstable branch
Message-Id: <20261111044328.234CD1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: update entry for Guodong Xu
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-entry-for-guodong-xu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-entry-for-guodong-xu.patch

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
From: Guodong Xu <guodong.xu@linux.dev>
Subject: mailmap: update entry for Guodong Xu
Date: Fri, 6 Nov 2026 16:30:48 -0500

Use my linux.dev address for kernel correspondence, including for
contributions made with my other email addresses. It is not tied to
a personal or employer mailbox.

Link: https://lore.kernel.org/7e9369cf1473539bafe9cb90207ba6fe98b534ca.1794001419.git.guodong.xu@linux.dev
Signed-off-by: Guodong Xu <guodong.xu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/.mailmap~mailmap-update-entry-for-guodong-xu
+++ a/.mailmap
@@ -359,8 +359,10 @@ Gokul Sriram Palanisamy <quic_gokulsri@q
 Govindaraj Saminathan <quic_gsamin@quicinc.com> <gsamin@codeaurora.org>
 Guo Ren <guoren@kernel.org> <guoren@linux.alibaba.com>
 Guo Ren <guoren@kernel.org> <ren_guo@c-sky.com>
-Guodong Xu <docular.xu@gmail.com> <guodong.xu@linaro.org>
-Guodong Xu <docular.xu@gmail.com> <guodong@riscstar.com>
+Guodong Xu <guodong.xu@linux.dev> <docular.xu@gmail.com>
+Guodong Xu <guodong.xu@linux.dev> <guodong.xu@linaro.org>
+Guodong Xu <guodong.xu@linux.dev> <guodong.xu@oss.qualcomm.com>
+Guodong Xu <guodong.xu@linux.dev> <guodong@riscstar.com>
 Guru Das Srinagesh <linux@gurudas.dev>
 Guru Das Srinagesh <linux@gurudas.dev> <quic_gurus@quicinc.com>
 Guru Das Srinagesh <linux@gurudas.dev> <gurus@codeaurora.org>
_

Patches currently in -mm which might be from guodong.xu@linux.dev are

mailmap-update-entry-for-guodong-xu.patch

