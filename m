Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324D919004A
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 02:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779415617; cv=none; b=uikZNDJJBQ1qffCDIt5QPpk6RWQZ6ITmZJnioKh7zDsWwrZUAg3bw8kEUa1Cm9JVtYQh2OYF2HCrOUg3Cbsl0+T7yQ+F0Idb7MSj4ljuTkdubxbJUh/Vc8UTulp8cZlgEHid0cWLJIggqpOKvcyvYMtWHEmnHgddsaQyL5hyDSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779415617; c=relaxed/simple;
	bh=hRiJr/mYlNKpdxAr3HAu1Ru4yXPTc9rLae0bCTmYzvI=;
	h=Date:To:From:Subject:Message-Id; b=T9jHZjhbYCNoHjkPadqsxdUZ7KDSV+/AYvHmwrZlz6LLQpGKspt+bVuX3pRNcoXv5mNfzdEVUQc0ilvkUeoCM0x9u8Aqe3Y4SCxIkU2hOqUYkcgboIkLa3f9NtxQvt+Azr93TRWbkCy8J/7Tti2mROxOhYnSCfFxuBQEZGVGdBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=STROk8g8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="STROk8g8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79F11F000E9;
	Fri, 22 May 2026 02:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779415612;
	bh=JZO4UqvFDBsqyPCG/iVIXBD2u2Gv77NBjUnP0mwWJww=;
	h=Date:To:From:Subject;
	b=STROk8g8G7BRsMrbe9F4r7hnlAv1xf3KjI0h4aRuY6jcrMDyJT496dz1Q2yStAjHc
	 UMRlUzhJM5pStJ8YPGh1c5V1kHPmrhoz0VvE/H11PNCsXJsAJfPx7fW1vkVfzFjA/N
	 3kqXowPJx3uHKhgm56ZpKMXDq6ct7Quf8HJkHNxc=
Date: Thu, 21 May 2026 19:06:52 -0700
To: mm-commits@vger.kernel.org,neil.armstrong@linaro.org,luca.ceresoli@bootlin.com,ian.ray@gehealthcare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mailmap-update-after-gehc-spin-off.patch removed from -mm tree
Message-Id: <20260522020652.A79F11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: .mailmap: update after GEHC spin-off
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-after-gehc-spin-off.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ian Ray <ian.ray@gehealthcare.com>
Subject: MAINTAINERS: .mailmap: update after GEHC spin-off
Date: Wed, 6 May 2026 09:33:35 +0300

Update my email address from @ge.com to @gehealthcare.com after GE
HealthCare was spun-off from GE.

Link: https://lore.kernel.org/20260506063335.3-1-ian.ray@gehealthcare.com
Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-mailmap-update-after-gehc-spin-off
+++ a/.mailmap
@@ -339,6 +339,7 @@ Henrik Rydberg <rydberg@bitmath.org>
 Herbert Xu <herbert@gondor.apana.org.au>
 Huacai Chen <chenhuacai@kernel.org> <chenhc@lemote.com>
 Huacai Chen <chenhuacai@kernel.org> <chenhuacai@loongson.cn>
+Ian Ray <ian.ray@gehealthcare.com> <ian.ray@ge.com>
 Ignat Korchagin <ignat@linux.win> <ignat@cloudflare.com>
 Igor Korotin <igor.korotin@linux.dev> <igor.korotin.linux@gmail.com>
 Ike Panhc <ikepanhc@gmail.com> <ike.pan@canonical.com>
--- a/MAINTAINERS~maintainers-mailmap-update-after-gehc-spin-off
+++ a/MAINTAINERS
@@ -16504,7 +16504,7 @@ F:	drivers/usb/mtu3/
 
 MEGACHIPS STDPXXXX-GE-B850V3-FW LVDS/DP++ BRIDGES
 M:	Peter Senna Tschudin <peter.senna@gmail.com>
-M:	Ian Ray <ian.ray@ge.com>
+M:	Ian Ray <ian.ray@gehealthcare.com>
 M:	Martyn Welch <martyn.welch@collabora.co.uk>
 S:	Maintained
 F:	Documentation/devicetree/bindings/display/bridge/megachips-stdpxxxx-ge-b850v3-fw.txt
_

Patches currently in -mm which might be from ian.ray@gehealthcare.com are


