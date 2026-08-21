Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC52366054;
	Fri, 21 Aug 2026 03:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787281892; cv=none; b=pt9iPBzthOpZtlMjCDSGa7M0uYi3fHc3/zXIpgNY0KQAHT1eOymqh9aK7gTphitQwK+egXhPt4RWzKAbx7CPlmgK9lxQZKr0NnXDlKFs8wpppGHUnyloOCahj6xZ3EHvfPip3Q5dDbRm6VeecxWNSUMbOT3o+uJ3HT950fnxnO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787281892; c=relaxed/simple;
	bh=UOiyRFza4OMCt4BdBOuAcaOb7LqGvtbuy2/VEM739WA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=QeBH0uAWRLGLCmtu0VBwdbMDdn1RoW3dErEVHM8kuqr6ILtzPWwDXnyNSAcRGSeovqbZ9SVAtl3/0rN687INwOjTS1b3pRv3UJhKvLEY7QcEtyWmmrl+/9HoAVhC52wNBt5pC9K07Zm/nwCKMqOWEmTRPcplySH00MPAIBulULg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHFbIj+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHFbIj+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE03E1F00AC4;
	Fri, 21 Aug 2026 03:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787281868;
	bh=/vJgYywuEJWZEkQKz8Bj/wRfo7NzO/GxYPEKUCdHC74=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=GHFbIj+jKw801WtVy7IMdhU7xpQ187sKsLpPKElsjl+yGwPhv2cRtJsISYfPREIFP
	 XU+xBddmtsjPaXkPDbRnB30TfvS+EHpXbBnGH4xOP0e/Zly41dITOP8MUf3/hMw2vk
	 +r3gg1EbJK/ncWtk0krZSiUAyJwDcAcc7IX0tRRdlvyU/M2kS8kjq1dyBGplDYU7dV
	 mAFNzjfJTLG7hdwjrENeeByD/0HAx9FjJn4xddAx29ja3XNZ3cO0o58op7Gnimk5Gh
	 E2Y8S/SunAMCFCBTVheZLOdlAstm1E1U5SQK1lKHDTVCx1kMuMDij0PhGcYxYQE2Xf
	 JjLm0K0XWAX4w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19B7A3924A4B;
	Fri, 21 Aug 2026 03:10:20 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260818220711.d5d577cb135b213ae11549c9@linux-foundation.org>
References: <20260818220711.d5d577cb135b213ae11549c9@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260818220711.d5d577cb135b213ae11549c9@linux-foundation.org>
X-PR-Tracked-Remote: https://lore.kernel.org/anSSANY5zZu4kytE@sirena.org.uk Thanks.
X-PR-Tracked-Commit-Id: 08745c62350126bc31b09548137be87e2866f628
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ed3b875bea55a3ec4837113356df2ead11115af9
Message-Id: <178728181878.600189.588163658498005550.pr-tracker-bot@kernel.org>
Date: Fri, 21 Aug 2026 03:10:18 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 18 Aug 2026 22:07:11 -0700:

> https://lore.kernel.org/anSSANY5zZu4kytE@sirena.org.uk Thanks.

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ed3b875bea55a3ec4837113356df2ead11115af9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
