Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794973171;
	b=RQhVbLn0rWuBN0rK4MO9VJ138V7iGTSxfmTRX40UvppJvNkajPTVWo7e2qB2Xz+BOOnV
	 kHhoTjGt6ydRhsjA1/cOUs1y1R8IyPvzVT+jwl7X7+Ms5MoECgVfCd13aMRrNVt5liTFl
	 v0h460jZCTmoeUQvEDyY9MGS6ZfoXhIT50auCAAWr6ZU0XXfqa93DJOhlhyIBv5t19LU7
	 FI5OFUQnHe57p+3mgFkPufjPt4SVobbhvdt7/Mefpa5CtUYZDV54VrpNpg+1lIpXMyide
	 txFrp8YO4VrXLIurr0TIARCbRBQdXHsWIis7HxfBYgPouSTqi/9g10s90M/dFwAmiNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794973171;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=4yXPS4KozUo7UaEim5Qn33mv4xka6Uh1cNLvPB64jpA=;
	b=UFz94AtfqSBsA+H8CBFZGYFlXp2BC3Vz5w/UeqXottRJdpwYujIWK2f6WA1mJgApnjQR
	 k2MDZ1wOIbrhnCUNh8gyNLzEUqiJ5Wa294TNDK/sagrkRrCElmVO/l8wt8v5wzMam2uyf
	 H3GKLQElfWr+s5KvMPA1QcPGaEBPbPs4iKKenOEN5vXpEQr0Iir3U/XJuHgJ2YbVfZQkW
	 IuO5trS0yKAQC0TX0PdUUMbTphp8uFA5lWyFwkH+8pR0uy90kHJ0VT+lbD1skrmKbgyZn
	 m4fbs9EGtC3F+TmXkWoA706V92g9q38uDqMvk7CZ8GIEPyUYFDiSqXolAMRn0ttusAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wRGKBKp7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AC4606A332
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 03:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wRGKBKp7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB7D1F000C6;
	Wed, 18 Nov 2026 03:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794973170;
	bh=4yXPS4KozUo7UaEim5Qn33mv4xka6Uh1cNLvPB64jpA=;
	h=Date:To:From:Subject;
	b=wRGKBKp7TZHmXmZCD3wuXPe9bYSp69kIElUA9gySP5UyqiXQrOotocwfIeimkvd+o
	 dKh7T7I56cENu9lUf2BNKkiGEJbTvmLryYXXW43PQJ2bSZPZIsa03ttTfL/Clum4do
	 74god5iTOL3rCsV7Brq9G1W3oCptPAxXWzITGZOk=
Date: Tue, 17 Nov 2026 19:39:30 -0800
To: mm-commits@vger.kernel.org,kuba@kernel.org,jeff.johnson@oss.qualcomm.com,
	hawk@kernel.org,dianders@chromium.org,cel@kernel.org,
	bastien.curutchet@bootlin.com,alex@sverdlin.org,namjain@linux.microsoft.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-naman-jain.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261118033930.CFB7D1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: update email address for Naman Jain
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     mailmap-update-email-address-for-naman-jain.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-naman-jain.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
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
From: Naman Jain <namjain@linux.microsoft.com>
Subject: mailmap: update email address for Naman Jain
Date: Tue, 17 Nov 2026 08:45:42 +0000

My Qualcomm email address is no longer accessible. Map it to my current
Microsoft email address.

Link: https://lore.kernel.org/20261117084542.2076622-1-namjain@linux.microsoft.com
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Alexander Sverdlin <alex@sverdlin.org>
Cc: Chuck Lever <cel@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-naman-jain
+++ a/.mailmap
@@ -695,6 +695,7 @@ Mythri P K <mythripk@ti.com>
 Nadav Amit <nadav.amit@gmail.com> <namit@vmware.com>
 Nadav Amit <nadav.amit@gmail.com> <namit@cs.technion.ac.il>
 Nadia Yvette Chambers <nyc@holomorphy.com> William Lee Irwin III <wli@holomorphy.com>
+Naman Jain <namjain@linux.microsoft.com> <quic_namajain@quicinc.com>
 Naoya Horiguchi <nao.horiguchi@gmail.com> <n-horiguchi@ah.jp.nec.com>
 Naoya Horiguchi <nao.horiguchi@gmail.com> <naoya.horiguchi@nec.com>
 Natalie Vock <nat@pixelcluster.dev> <friedrich.vock@gmx.de>
_

Patches currently in -mm which might be from namjain@linux.microsoft.com are

mailmap-update-email-address-for-naman-jain.patch

