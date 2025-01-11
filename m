Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493DD199924
	for <mm-commits@vger.kernel.org>; Sat, 11 Jan 2025 23:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736638000; cv=none; b=ee/mD0iY7lOMu8ZKpIveovuouNM7MBC9Umkz7JvS8POl/2SaE+tU4mwvN6W8tWuubFSnIsygttGE24ME8eWik6BBZ04XN9eWoYPAtCrlTnLOywSPNjI7OMiqWaD5/wwfZvcLU9/DVFMLZ6rxqVJBbd2gLRf1Agcol/7rt/Rx9IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736638000; c=relaxed/simple;
	bh=Vk6zb3vR0qIGRasQYLsx4MCnnY/0Ivo9R8n+gX5xfRY=;
	h=Date:To:From:Subject:Message-Id; b=VoPS3xRk45Fq/VHXvWDUwfb7/k4OUSgIO3Z51WzSyPXsRmJJBgG6slZc6DE2lxWvPiEgomiK8021mkwzkaSE6C6sJoLjsc4QvL3mL4/3ExXVKQlTrXVf/IGY6AMBBK2dtEvrea0qbdnNCRalTj4UJrFP8ZPdk179dDG07ibLuus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=moqiegJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="moqiegJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83AFC4CED2;
	Sat, 11 Jan 2025 23:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736637999;
	bh=Vk6zb3vR0qIGRasQYLsx4MCnnY/0Ivo9R8n+gX5xfRY=;
	h=Date:To:From:Subject:From;
	b=moqiegJ1rCCgWdBYTGeaCgCKDHFRV+/F/U+y+LtnFqz3lzBel8XB7EglLip49+VLQ
	 7ha8wurihQ2IjQ7gOWPFQfPlkRoG75Op1S8jPZz5hAiVlozid0aujfMz+E7ZDVG4hR
	 uJy7pukf9f/E4Ya/qjcLOTvt6WWVLd9pQaxd83vI=
Date: Sat, 11 Jan 2025 15:26:39 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,anupnewsmail@gmail.com,tanyaagarwal25699@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + credits-fix-spelling-mistakes.patch added to mm-nonmm-unstable branch
Message-Id: <20250111232639.A83AFC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: CREDITS: fix spelling mistakes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     credits-fix-spelling-mistakes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/credits-fix-spelling-mistakes.patch

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
From: Tanya Agarwal <tanyaagarwal25699@gmail.com>
Subject: CREDITS: fix spelling mistakes
Date: Sun, 12 Jan 2025 01:17:10 +0530

Fix spelling errors identified using codespell tool.

Link: https://lkml.kernel.org/r/20250111194709.51133-1-tanyaagarwal25699@gmail.com
Signed-off-by: Tanya Agarwal <tanyaagarwal25699@gmail.com>
Cc: Anup Sharma <anupnewsmail@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/CREDITS~credits-fix-spelling-mistakes
+++ a/CREDITS
@@ -4327,7 +4327,7 @@ D: Freescale Highspeed USB device driver
 D: Freescale QE SoC support and Ethernet driver
 S: B-1206 Jingmao Guojigongyu
 S: 16 Baliqiao Nanjie, Beijing 101100
-S: People's Repulic of China
+S: People's Republic of China
 
 N: Vlad Yasevich
 E: vyasevich@gmail.com
_

Patches currently in -mm which might be from tanyaagarwal25699@gmail.com are

credits-fix-spelling-mistakes.patch

