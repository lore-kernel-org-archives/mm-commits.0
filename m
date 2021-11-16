Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59470C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FD6961B30
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344528AbhKPEZm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344448AbhKPEZ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 Nov 2021 23:25:28 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F4DC2029AF
        for <mm-commits@vger.kernel.org>; Mon, 15 Nov 2021 17:16:55 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HtSnx0h3yz4xg1;
        Tue, 16 Nov 2021 12:16:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1637025413;
        bh=UGXZ39QbDKZMSEWtT+jUCWZD7NrYCjYjRbtAtuhgkto=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HPJaSvVOoMqFxJpnyr9DoipS5J8L2UwV4gZBFSmEhIrpmWUb7E+ikxHihmcLuPTJW
         8D4wDPtfq/SKeaWqmu8AFWA6Aj+VqCO8dje+DVR5kJ+E0/08ILcGHbHja/DXULsG7p
         tOL6Gs8OdslS9DRLPe8J9s7X+IV3nYcQLxV8FuOiGzekqSK8zHc8FMRaZkx7l50xmj
         CTOBs1SFq0ohzE3wleCl9v1kIzbmf/x2A8JorvS2kVvIIANqC3qXon/BBLjQLHTAUG
         USXB7ToNpWkIMdBVNXCGbpC+vLvH7OERav3URU1QKt3mhx2LVT7JlNwfCIMu/jLvKj
         FyDwmC49j2CnA==
Date:   Tue, 16 Nov 2021 12:16:52 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     daniel.thompson@linaro.org, dvyukov@google.com, elver@google.com,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, paulmck@kernel.org,
        quic_qiancai@quicinc.com, rdunlap@infradead.org
Subject: Re: + configs-introduce-debugconfig-for-ci-like-setup.patch added
 to -mm tree
Message-ID: <20211116121652.742f4bec@canb.auug.org.au>
In-Reply-To: <20211115181106._HRCT6dJM%akpm@linux-foundation.org>
References: <20211115181106._HRCT6dJM%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Hr=btAI9ZlCQbw+G=RHNgZR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/Hr=btAI9ZlCQbw+G=RHNgZR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 15 Nov 2021 10:11:06 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: configs: introduce debug.config for CI-like setup
> has been added to the -mm tree.  Its filename is
>      configs-introduce-debugconfig-for-ci-like-setup.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/Hr=btAI9ZlCQbw+G=RHNgZR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGTBoQACgkQAVBC80lX
0GyIygf+NPULE7w/n5V+ADSwXnDVotB3fU4tdfNt3IH8cnmkEpPNt7/17D94m7oJ
DxVpJwhQT/PLB5BYiyR0IxBnMWrEzultDHxH5dA1GS5YMkOt4ZeRsoao8FdgnMpp
qmQFp3Om6W82+RBktjSuEkN2FLci/6y38Vei7E8d+eLuDmdcH+sMEHyDfYn6uxJ3
6SCpKNE1vK0fJEUnm+/myfSu8huG/m9cw9G6kY2dU15z7dck0a5raOx+F0SvXJcB
wwGEhrJPO8aNu7eHdNCLLmV20Y1UaxIozuz3cv4yY+DWb5IiL9NixLkFK//Ugcdo
dh1OR2R5Sw8z0iPSCSAFF1h5jwPcIA==
=p0mK
-----END PGP SIGNATURE-----

--Sig_/Hr=btAI9ZlCQbw+G=RHNgZR--
