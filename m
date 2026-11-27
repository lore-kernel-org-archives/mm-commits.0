Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795738870;
	b=vFu3nYurtms12/Z+/7LcDf+i9XZ3OoJ7MA0makfvsE56hjGnCMQaUgK+QDGhtDGWRHgp
	 bcsSFCx19Weosyo1+/hyEISHfCO8e/xoqbEz+CSulUs3hITBvC3seNnbqnPtiVq4VTA8W
	 yhwjSS6n2jO8nvFflVOo6tACWLjZUxUfdfEHN3Pb2XK81oFASVx8MiPUkfZoffojhTJVU
	 R8jX7S1vyv/asKst6BvrnzlUzlWXx1/JyUlKIMuh60X2VMawO+8BTLzUXq1W6xZ4loLxQ
	 HdveNrvFhHrXz5GAFf0ibDLo42MTJ93WScuY6w2HCZBPm5aRve8Jb6coAw20egr71UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795738870;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=u8SehR6jEKECw2flcoJo+rwqlukikiJQlhjsBSaPj8k=;
	b=WoIJ1R58itVxDapd+3z+cn1LrhoEgxPM6aJYUQvM3wXSBTRWVzRia4sG6yal5Oq+Hn97
	 a3mOaz3rhmusFphKIe9WPC4yTobNw89ZTFpP0iQ7AfxH5jTK3O+ZqPnDNVDOoEzOzLwVz
	 GV4WrUBei28EtuzDLMVV6yRQyXv+AFofexwKrPxQkOXBK0zL+xNilqCZBb1LRpm0I45ql
	 WEAgS7+ObiFVszBSn/1IY9lEglyoKfXNgY7Sm0mwFaUIXJFkwX8wMAmXW4n1VNjiQWiVY
	 Vlt5S+6XwHtskmWBjrKSBBkRm+TMk7mS/cOlisDMPRHq1wTrQGvBOcChUZud6n4s8Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=emdnWdsp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE375606A31E
	for <mm-commits@vger.kernel.org>; Fri, 27 Nov 2026 00:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=emdnWdsp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084F41F0089A;
	Fri, 27 Nov 2026 00:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795738870;
	bh=u8SehR6jEKECw2flcoJo+rwqlukikiJQlhjsBSaPj8k=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=emdnWdspmHq6IqoZQltWATcAcSElVmxrY6kALKIHASNLJsHwMv+q3T8nnyMRlXiv2
	 MrUA2ajXJqDcKFQ8/blIwiQAJbbeUjEFU9Ba72QpRW5rSB5tNSC7bO1bYaNcGE1O3Q
	 1rvwk0g2lUFtUPDQ7hE+r+y4IqDRxAjN9tV9yrUc=
Date: Thu, 26 Nov 2026 16:21:09 -0800
To: mm-commits@vger.kernel.org,ycistak@gmail.com,linux@roeck-us.net,
	asafbertizlioglu@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261126170501.49888-1-asafbertizlioglu@gmail.com>
References: <20261126170501.49888-1-asafbertizlioglu@gmail.com>
Subject: + mailmap-add-entry-for-asaf-nuri-bertizlioglu.patch added to mm-nonmm-unstable branch
Message-Id: <20261127002110.084F41F0089A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: Add entry for Asaf Nuri Bertizlioğlu
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-entry-for-asaf-nuri-bertizlioglu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-asaf-nuri-bertizlioglu.patch

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
From: Asaf Nuri Bertizlioğlu <asafbertizlioglu@gmail.com>
Subject: mailmap: Add entry for Asaf Nuri Bertizlioğlu
Date: Thu, 26 Nov 2026 20:05:01 +0300

Map my old address to my new one.  The old address appears in existing
Tested-by and Signed-off-by tags; I will use the new address for all
future contributions.

Link: https://patch.msgid.link/20261126170501.49888-1-asafbertizlioglu@gmail.com
Signed-off-by: Asaf Nuri Bertizlioğlu <asafbertizlioglu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Asaf Nuri Bertizlioğlu <ycistak@gmail.com>

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-asaf-nuri-bertizlioglu
+++ a/.mailmap
@@ -128,6 +128,7 @@ Ard Biesheuvel <ardb@kernel.org> <ard.bi
 Arnaud Patard <arnaud.patard@rtp-net.org>
 Arnd Bergmann <arnd@arndb.de>
 Arun Kumar Neelakantam <quic_aneela@quicinc.com> <aneela@codeaurora.org>
+Asaf Nuri Bertizlioğlu <asafbertizlioglu@gmail.com> <ycistak@gmail.com>
 Asahi Lina <lina+kernel@asahilina.net> <lina@asahilina.net>
 Ashok Raj Nagarajan <quic_arnagara@quicinc.com> <arnagara@codeaurora.org>
 Ashwin Chaugule <quic_ashwinc@quicinc.com> <ashwinc@codeaurora.org>
_

Patches currently in -mm which might be from asafbertizlioglu@gmail.com are

mailmap-add-entry-for-asaf-nuri-bertizlioglu.patch

