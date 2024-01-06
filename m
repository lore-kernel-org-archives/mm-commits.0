Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3109C3C15;
	Sat,  6 Jan 2024 05:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gG67+Boh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 065C5C433C8;
	Sat,  6 Jan 2024 05:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704517468;
	bh=q/WzVRZpHOAvbucPbSrrmKYwXADrzRiNmaAqfuQhbMY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=gG67+Boh5/o0FPYxjDphhCtIH/yjXwU3LH/KVS7lJZqis8cB0X6qTOM9VVPUguMCd
	 5McjhVU5UGLROJLXsa1tBVuLRtxzZGpQH1fBtBwcKRww5K5gEG/WbhgP8ZZ49J8Hjp
	 eXRGjh6/Rcs3GYwVmaRxAtjCqwpiGa9ljqXGXu+z3Nyk4zcG40avPXEjOPgc8/4crI
	 HwALN7oWjTTYwgD2KAeZkvbbPw31/jZA86CbB/unAmLBp0zzU4FjwQGeUfEhShTlLk
	 pt8tGwj6//oHsfUQWFXN3bgAcmoWq4zZ5jjSsg5L84o19aIBWxv7sLRSZmiT7YuCbg
	 k6ZeYA9X22AWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E319DDCB6CD;
	Sat,  6 Jan 2024 05:04:27 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.8
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240105114314.820c25628928c57f639058fe@linux-foundation.org>
References: <20240105114314.820c25628928c57f639058fe@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240105114314.820c25628928c57f639058fe@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-01-05-11-35
X-PR-Tracked-Commit-Id: 7fba9420b726561966e1671004df60a08b39beb3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 95c8a35f1c017327eab3b6a2ff5c04255737c856
Message-Id: <170451746792.9519.10559423595952441430.pr-tracker-bot@kernel.org>
Date: Sat, 06 Jan 2024 05:04:27 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 5 Jan 2024 11:43:14 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-01-05-11-35

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/95c8a35f1c017327eab3b6a2ff5c04255737c856

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
